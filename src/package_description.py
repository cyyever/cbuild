#!/usr/bin/env python3
import copy
import json
import os
import sys
import typing

from cyy_naive_lib.algorithm.sequence_op import flatten_list
from cyy_naive_lib.shell.mingw64_script import Mingw64Script
from cyy_naive_lib.shell.pwsh_script import PowerShellScript
from cyy_naive_lib.shell_factory import get_shell_script_type
from cyy_naive_lib.util import readlines

from .build_action import BuildAction
from .config import Config, Environment, ToolMapping
from .environment import BuildContext, ports_dirs, scripts_dir, sources_dir
from .package_source.file_source import FileSource
from .package_source.git_source import GitSource
from .package_source.script_source import ScriptSource
from .package_source.tarball_source import TarballSource
from .package_spec import PackageSpecification


class PackageDescription:
    def __init__(self, specification):
        if not isinstance(specification, PackageSpecification):
            specification = PackageSpecification(specification)
        self.spec = specification
        if not os.path.isfile(self.__description_json_path()):
            sys.exit("unknown package:" + self.spec.name)

        description = {}
        with open(self.__description_json_path(), "r", encoding="utf-8") as f:
            description = json.load(f)

        self.__context = None
        self.features = None
        branch_description = description
        if self.spec.branch in description:
            branch_description = branch_description[self.spec.branch]
        if "docker" in branch_description and "docker" in BuildContext.get():
            branch_description = branch_description["docker"]
        if BuildContext.get_target_system() in branch_description:
            branch_description = branch_description[BuildContext.get_target_system()]
        else:
            for ctx in ["linux", "unix", "all_os"]:
                if ctx in BuildContext.get() and ctx in branch_description:
                    branch_description = branch_description[ctx]
                    break
        self.__config = Config([branch_description, description])
        self.__environment = Environment([branch_description, description])
        self.__check_language_feature = True
        self.__languages = None
        self.__build_tools = None
        self.__source = None

    def get_source(self):
        if self.__source is not None:
            return self.__source
        if self.get_item("script_package") or self.get_item("group_package"):
            self.__source = ScriptSource(self.spec)
            return self.__source

        url = self.__get_source_url()
        if GitSource.is_git_source(url):
            with_submodule = self.get_item("with_submodule")
            if with_submodule is None:
                with_submodule = True
            ignored_submodules = self.get_item("ignored_git_submodules")
            if ignored_submodules is not None:
                ignored_submodules = set(ignored_submodules)

            ignored_tag_regex = self.get_item("ignored_tag_regex")
            spec = copy.deepcopy(self.spec)
            git_branch = self.get_item("git_branch")
            if git_branch is not None:
                spec.branch = git_branch

            self.__source = GitSource(
                spec,
                git_url=url,
                root_dir=sources_dir,
                with_submodule=with_submodule,
                remote_url=self.get_item("remote_git_url"),
                remote_branch=self.get_item("remote_git_branch"),
                ignored_submodules=ignored_submodules,
                ignored_tag_regex=ignored_tag_regex,
            )
            return self.__source

        try:
            self.__source = TarballSource(
                self.spec,
                url,
                os.path.join(sources_dir, str(self.spec.name)),
                self.get_item("file_name"),
                self.get_item("checksum"),
            )
            return self.__source
        except TypeError:
            pass

        try:
            self.__source = FileSource(
                self.spec,
                url,
                os.path.join(sources_dir, str(self.spec.name)),
                self.get_item("file_name"),
                self.get_item("checksum"),
            )
            return self.__source
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

    def __check_languages(self) -> typing.Tuple[set, set]:
        if self.__languages is not None:
            return (self.__languages, self.__build_tools)
        building_tools = set()
        possible_languages = self.get_item("build_languages")
        if not possible_languages and self.__check_language_feature:
            self.__check_language_feature = False
            building_tools, possible_languages = ToolMapping().guess_language(
                self.__get_script_content(BuildAction.BUILD)
            )
            self.__check_language_feature = True
        if not possible_languages:
            possible_languages = set()
        else:
            possible_languages = set(possible_languages)
        lang = self.get_item("main_language")
        if lang and ToolMapping().is_supported_language(lang):
            possible_languages.add(lang)

        if self.__check_language_feature:
            self.__check_language_feature = False
            for manager in self.__get_system_package_dependency():
                langs = ToolMapping().get_languages(manager)
                for lang in langs:
                    building_tools.add(manager)
                    possible_languages.add(lang)
            self.__check_language_feature = True
        self.__build_tools = building_tools
        self.__languages = possible_languages
        return (self.__languages, self.__build_tools)

    def get_features(self):
        if self.features:
            return self.features
        self.features = self.spec.features

        languages, building_tools = self.__check_languages()

        self.features.update(["feature_language_" + lan for lan in languages])
        if "cmake" in building_tools:
            self.features.add("feature_building_tool_cmake")

        while True:
            new_features = self.__get_conditional_items_by_context(
                "new_feature", elements=(self.context | self.features)
            )
            has_new_feature = False
            for new_feature in new_features:
                if new_feature not in self.features:
                    self.features.add(new_feature)
                    has_new_feature = True
            if not has_new_feature:
                break
        return self.features

    def __get_shell_script(self):
        if "mingw64" in self.context:
            return Mingw64Script()
        script_type = get_shell_script_type(os_hint=BuildContext.get_target_system())
        script = script_type()
        return script

    def get_script(self, action):
        if action not in (
            BuildAction.BUILD,
            BuildAction.BUILD_WITH_CACHE,
            BuildAction.DOCKER_BUILD,
        ):
            raise RuntimeError("unsupported action")
        script = self.__get_shell_script()

        if "mingw64" in self.context:
            for item in self.__environment.get(
                lambda condition_expr: self.__check_conditions(
                    condition_expr, elements=["windows"]
                )
            ):
                pieces = item.split("=")
                name = pieces[0]
                if name == "INSTALL_PREFIX":
                    value = "=".join(pieces[1:])
                    pwsh_script = PowerShellScript()
                    pwsh_script.append_env(name, value)
                    pwsh_script.append_content("$env:" + name)
                    output, _ = pwsh_script.exec(throw=True)
                    script.append_env_path(name, output.strip())
                    continue
                if name == "PATH":
                    continue

        for item in self.__environment.get(self.__check_conditions):
            pieces = item.split("=")
            name = pieces[0]
            value = "=".join(pieces[1:])
            if name in {"INSTALL_PREFIX", "PATH"} and "mingw64" in self.context:
                continue
            script.append_env(name, value)

        for ctx in sorted(self.context):
            script.append_env("BUILD_CONTEXT_" + ctx, "1")

        for feature in sorted(self.get_features()):
            script.append_env("FEATURE_" + feature, "1")

        script_content = self.__get_script_content(BuildAction.PREPROCESS)
        if script_content:
            script.append_content(script_content)

        for manager, system_pkgs in self.__get_system_package_dependency().items():
            system_pkgs = sorted(list(system_pkgs))

            script.append_env(manager + "_pkgs", " ".join(system_pkgs))
            script_path = os.path.join(
                scripts_dir,
                "package_manager",
                manager + "." + script.get_suffix(),
            )
            if manager == "yay":
                self.features.add("feature_package_manager_yay")
            if not os.path.exists(script_path):
                sys.exit("unsupported system_package_dependency:" + script_path)
            script.append_content(readlines(script_path))

        cmake_options = " ".join(
            self.__get_conditional_items("cmake_options", global_to_local=True)
        )
        script.prepend_env("PACKAGE_NAME", self.spec.name)
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
        script_content = self.__get_script_content(BuildAction.AFTER_INSTALL)
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

        system_pkgs = {}
        for value in self.__get_conditional_items("system_package_dependency"):
            for (manager, item) in value.items():
                if (
                    not tool_mapping.is_supported_tool(manager)
                    and manager not in managers
                ):
                    if manager in self.context:
                        # use first manager
                        manager = managers[0]
                    else:
                        continue
                if manager not in system_pkgs:
                    system_pkgs[manager] = set()
                system_pkgs[manager].update(item)
        return system_pkgs

    def __get_conditional_items_by_context(self, key, elements):
        values = self.__config.conditional_get(
            key, lambda x: self.__check_conditions(x, elements=elements)
        )
        return flatten_list(values)

    def __get_conditional_items(self, key, global_to_local=False):
        values = self.__config.conditional_get(
            key, self.__check_conditions, global_to_local=global_to_local
        )
        return flatten_list(values)

    def __check_conditions(self, condition_expr, elements=None):
        if elements is None:
            elements = self.context | self.get_features()
        conditions = condition_expr.split("||")
        for condition in conditions:
            if PackageDescription.__check_and_conditions(condition, elements):
                return True
        return False

    @staticmethod
    def __check_and_conditions(condition_expr, elements):
        conditions = [c.strip() for c in condition_expr.split("&&")]
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
        script = self.__get_shell_script()
        script_suffix = script.get_suffix()
        possible_systems = []
        for system in [
            BuildContext.get_target_system(),
            "linux",
            "bsd",
            "unix",
            "all_os",
        ]:
            if system in self.context:
                possible_systems.append(system)
        branches = [self.spec.branch]
        for b in [
            "__cbuild_most_recent_git_tag",
            "main",
            "master",
        ]:
            if b not in branches:
                branches.append(b)

        paths = []

        if action in (
            BuildAction.PREPROCESS,
            BuildAction.AFTER_INSTALL,
        ):
            if action == BuildAction.PREPROCESS:
                additional_suffix = "preprocess"
            else:
                additional_suffix = "after_install"
            for system in possible_systems:
                script_path = os.path.join(
                    scripts_dir,
                    additional_suffix,
                    system + "." + script_suffix,
                )
                if os.path.isfile(script_path):
                    paths.append(script_path)
            for system in possible_systems:
                for branch in branches:
                    script_path = os.path.join(
                        self.port_dir(),
                        branch,
                        system
                        + "."
                        + additional_suffix
                        + "."
                        + self.__get_shell_script().get_suffix(),
                    )
                    if os.path.isfile(script_path):
                        paths.append(script_path)
            return paths

        if action in (
            BuildAction.BUILD,
            BuildAction.BUILD_WITH_CACHE,
            BuildAction.DOCKER_BUILD,
        ):
            if self.get_item("main_language"):
                build_script_dir = os.path.join(
                    scripts_dir, "build", self.get_item("main_language")
                )
                for system in possible_systems:
                    script_path = os.path.join(
                        build_script_dir, system + "." + script_suffix
                    )
                    if os.path.isfile(script_path):
                        paths.append(script_path)
            else:
                for system in possible_systems:
                    for branch in branches:
                        script_path = os.path.join(
                            self.port_dir(),
                            branch,
                            system + "." + self.__get_shell_script().get_suffix(),
                        )
                        if os.path.isfile(script_path):
                            paths.append(script_path)
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
        raise RuntimeError(f"No port for package {self.spec.name}")

    def __description_json_path(self):
        return os.path.join(self.port_dir(), "description.json")

    @property
    def context(self):
        if self.__context is None:
            ctx = BuildContext.get()
            if BuildContext.get_host_system() == "windows" and self.get_item(
                "use_mingw64", False
            ):
                ctx.remove("windows")
                ctx.add("mingw64")
                ctx.add("linux")
                ctx.add("unix")
            self.__context = ctx
        return self.__context
