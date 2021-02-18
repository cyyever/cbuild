#!/usr/bin/env python3
import json
import os
import sys
from enum import Enum, auto
from pathlib import Path

from naive_lib.cyy_naive_lib.algorithm.sequence_op import flatten_list
from naive_lib.cyy_naive_lib.shell_factory import get_shell_script
from naive_lib.cyy_naive_lib.util import readlines

from .config import Config, Environment, ToolMapping
from .environment import BuildContext, ports_dirs, scripts_dir, sources_dir
from .package_source.file_source import FileSource
from .package_source.git_source import GitSource
from .package_source.script_source import ScriptSource
from .package_source.tarball_source import TarballSource
from .package_spec import PackageSpecification


class PackageDescription:
    # @innerclass
    class BuildAction(Enum):
        PREPROCESS = auto()
        BUILD = auto()
        BUILD_WITH_CACHE = auto()
        DOCKER_BUILD = auto()
        AFTER_INSTALL = auto()

    def __init__(self, specification):
        if not isinstance(specification, PackageSpecification):
            specification = PackageSpecification(specification)
        self.spec = specification
        if not os.path.isfile(self.__description_json_path()):
            sys.exit("unknown package:" + self.spec.name)

        description = {}
        with open(self.__description_json_path(), "r") as f:
            description = json.load(f)

        self.context = None
        self.features = None
        branch_description = {}
        if self.spec.branch in description:
            branch_description = description[self.spec.branch]
        elif "all_branches" in description:
            branch_description = description["all_branches"]
        if BuildContext.get_target_system() in branch_description:
            branch_description = branch_description[BuildContext.get_target_system()]
        else:
            for ctx in ["linux", "unix", "all_os"]:
                if ctx in BuildContext.get() and ctx in branch_description:
                    branch_description = branch_description[ctx]
                    break
        self.__config = Config([branch_description, description])
        self.__environment = Environment([branch_description, description])
        self.check_language_feature = True

    def get_source(self):
        if self.get_item("script_package") or self.get_item("group_package"):
            return ScriptSource(self.spec)

        url = self.__get_source_url()
        if GitSource.is_git_source(url):
            with_submodule = self.get_item("with_submodule")
            if with_submodule is None:
                with_submodule = True
            ignored_submodules = self.get_item("ignored_git_submodules")
            if ignored_submodules is not None:
                ignored_submodules = set(ignored_submodules)

            ignored_tag_regex = self.get_item("ignored_tag_regex")

            source = GitSource(
                self.spec,
                url,
                sources_dir,
                with_submodule=with_submodule,
                ignored_submodules=ignored_submodules,
                ignored_tag_regex=ignored_tag_regex,
            )
            return source

        try:
            return TarballSource(
                self.spec,
                url,
                sources_dir,
                self.get_item("file_name"),
                self.get_item("checksum"),
            )
        except TypeError:
            pass

        try:
            return FileSource(
                self.spec,
                url,
                sources_dir,
                self.get_item("file_name"),
                self.get_item("checksum"),
            )
        except TypeError:
            pass

        sys.exit("unknown source:" + str(self.spec))

    def __get_source_url(self):
        url = None
        for key in ["url", "git_url"]:
            url = self.get_item(key)
            if url is not None:
                break

        return url

    def get_docker_base_image(self):
        return self.__get_conditional_items("docker_base_image")[0]

    def disable_build_cache(self):
        self.__config.set("cache_time", None)

    def get_all_branchs(self):
        return {
            Path(f).stem for f in os.listdir(self.port_dir()) if f != "description.json"
        }

    def get_features(self):
        if self.features:
            return self.features
        self.features = self.spec.features

        building_tools = set()
        possible_languages = self.get_item("build_languages")
        if not possible_languages:
            building_tools, possible_languages = ToolMapping().guess_language(
                self.__get_script_content(PackageDescription.BuildAction.BUILD)
            )

        if self.check_language_feature:
            self.check_language_feature = False
            for manager in self.__get_system_package_dependency():
                langs = ToolMapping().get_languages(manager)
                for lang in langs:
                    building_tools.add(manager)
                    possible_languages.add(lang)
            self.check_language_feature = True

        self.features.update(["feature_language_" + lan for lan in possible_languages])
        if "cmake" in building_tools:
            self.features.add("feature_building_tool_cmake")

        while True:
            new_features = self.__get_conditional_items_by_context(
                "new_feature", context=(BuildContext.get() | self.features)
            )
            has_new_feature = False
            for new_feature in new_features:
                if new_feature not in self.features:
                    self.features.add(new_feature)
                    has_new_feature = True
            if not has_new_feature:
                break
        return self.features

    def get_script(self, action):
        if action not in (
            PackageDescription.BuildAction.BUILD,
            PackageDescription.BuildAction.BUILD_WITH_CACHE,
            PackageDescription.BuildAction.DOCKER_BUILD,
        ):
            raise RuntimeError("unsupported action")
        script = get_shell_script()
        for item in self.__environment.get(self.__check_conditions):
            pieces = item.split("=")
            script.append_env(pieces[0], "=".join(pieces[1:]))

        for ctx in sorted(BuildContext.get()):
            script.append_env("BUILD_CONTEXT_" + ctx, "1")

        for feature in sorted(self.get_features()):
            script.append_env("FEATURE_" + feature, "1")

        script_content = self.__get_script_content(
            PackageDescription.BuildAction.PREPROCESS
        )
        if script_content:
            script.append_content(script_content)

        for manager, system_pkgs in self.__get_system_package_dependency().items():
            system_pkgs = sorted(list(system_pkgs))

            script.append_env(manager + "_pkgs", " ".join(system_pkgs))
            script_path = os.path.join(
                scripts_dir,
                "package_manager",
                manager + "." + get_shell_script().get_suffix(),
            )
            if not os.path.exists(script_path):
                sys.exit("unsupported system_package_dependency:" + script_path)
            script.append_content(readlines(script_path))

        cmake_options = " ".join(
            self.__get_conditional_items("cmake_options", global_to_local=True)
        )
        script.prepend_env("PACKAGE_VERSION", self.spec.branch)
        script.append_env("cmake_options", cmake_options)
        script.append_env(
            "configure_options",
            " ".join(
                self.__get_conditional_items("configure_options", global_to_local=True)
            ),
        )

        script_content = self.__get_script_content(action)
        if script_content:
            script.append_content(script_content)
        else:
            if not self.get_item("group_package"):
                sys.exit("no build script for package:" + self.spec.name)
        script_content = self.__get_script_content(
            PackageDescription.BuildAction.AFTER_INSTALL
        )
        if script_content:
            script.append_content(script_content)
        return script

    def __get_script_content(self, action):
        content = []
        paths = self.__get_script_paths(action)
        if paths:
            for path in paths:
                content += readlines(path)
        return content

    def __get_system_package_dependency(self):
        managers = []
        for value in self.__get_conditional_items("system_package_manager"):
            managers.append(value)

        tool_mapping = ToolMapping()

        system_pkgs = dict()
        for value in self.__get_conditional_items("system_package_dependency"):
            for (manager, item) in value.items():
                if (
                    not tool_mapping.is_supported_tool(manager)
                    and manager not in managers
                ):
                    if manager in BuildContext.get():
                        # use first manager
                        manager = managers[0]
                    else:
                        continue
                if manager not in system_pkgs:
                    system_pkgs[manager] = set()
                system_pkgs[manager].update(item)
        return system_pkgs

    def __get_conditional_items_by_context(self, key, context=BuildContext.get()):
        values = self.__config.conditional_get(
            key, lambda x: self.__check_conditions(x, elements=context)
        )
        return flatten_list(values)

    def __get_conditional_items(self, key, global_to_local=False):
        values = self.__config.conditional_get(
            key, self.__check_conditions, global_to_local=global_to_local
        )
        return flatten_list(values)

    def __check_conditions(self, condition_expr, elements=None):
        if elements is None:
            elements = BuildContext.get() | self.get_features()
        conditions = condition_expr.split("&&")
        for condition in conditions:
            flag = None
            if condition.startswith("!"):
                flag = condition[1:] not in elements
            else:
                flag = condition in elements
            if not flag:
                return False
        return True

    def __get_script_paths(self, action):
        paths = []
        additional_suffix = ""
        if action == PackageDescription.BuildAction.PREPROCESS:
            if "unix" in BuildContext.get():
                paths.append(os.path.join(scripts_dir, "preprocess", "unix.sh"))
            if "windows" in BuildContext.get():
                paths.append(os.path.join(scripts_dir, "preprocess", "windows.ps1"))
            additional_suffix = ".preprocess"
        elif action == PackageDescription.BuildAction.AFTER_INSTALL:
            if "unix" in BuildContext.get():
                paths.append(os.path.join(scripts_dir, "after_install", "unix.sh"))
            if "windows" in BuildContext.get():
                paths.append(os.path.join(scripts_dir, "after_install", "windows.ps1"))

            additional_suffix = ".after_install"
        possible_systems = [BuildContext.get_target_system()]
        for system in ["linux", "unix", "all_os"]:
            if system in BuildContext.get():
                possible_systems.append(system)

        for system in possible_systems:
            for branch in [
                self.spec.branch,
                "__cbuild_most_recent_git_tag",
                "master",
                "main",
            ]:
                script_path = os.path.join(
                    self.port_dir(),
                    branch,
                    system
                    + additional_suffix
                    + "."
                    + get_shell_script(
                        os_hint=BuildContext.get_target_system()
                    ).get_suffix(),
                )
                if os.path.isfile(script_path):
                    paths.append(script_path)
                    return paths
        if (
            action
            in (
                PackageDescription.BuildAction.BUILD,
                PackageDescription.BuildAction.BUILD_WITH_CACHE,
                PackageDescription.BuildAction.DOCKER_BUILD,
            )
            and self.get_item("default_build_script")
        ):
            path = os.path.join(
                scripts_dir,
                "build",
                self.get_item("default_build_script"),
            )
            if BuildContext.get_target_system() == "windows":
                path = os.path.join(path, "windows.ps1")
            else:
                path = os.path.join(path, "unix.sh")
            paths.append(path)
            return paths
        return paths

    def get_item(self, key: str, default=None):
        return self.__config.get(key, default)

    def get_dependency(self):
        dependency_list = self.__get_conditional_items("dependency")
        dependency_set = set(dependency_list)
        dependency_set = {PackageSpecification(x) for x in dependency_set}

        if self.spec in dependency_set:
            dependency_set.remove(self.spec)
        return dependency_set

    def port_dir(self):
        for ports_dir in ports_dirs:
            port_dir = os.path.join(ports_dir, self.spec.name)
            if os.path.isdir(port_dir):
                return port_dir
        return None

    def __description_json_path(self):
        return os.path.join(os.path.join(self.port_dir(), "description.json"))
