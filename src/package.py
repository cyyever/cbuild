#!/usr/bin/env python3
# import copy
import os
import shutil
import sys
import time

from cyy_naive_lib.shell.docker_file import DockerFile
from cyy_naive_lib.shell_factory import exec_cmd

from . import environment
from .build_action import BuildAction
from .environment import BuildContext
from .package_description import PackageDescription


class Package:
    def __init__(self, specification):
        self.desc = PackageDescription(specification)

    @property
    def source(self):
        return self.desc.get_source()

    @property
    def name(self):
        return self.desc.spec.name

    @property
    def branch(self):
        return self.desc.spec.branch

    def full_name(self):
        return f"{self.name}-{self.branch}"

    def specification(self):
        return self.desc.spec

    def get_tag_file(self):
        return os.path.join(
            environment.tag_dir, (str(self.specification()) + ".tag").replace("/", "_")
        )

    def check_cache(self, new_hash=None):
        tag_file = self.get_tag_file()
        if not os.path.isfile(tag_file):
            return False

        cache_time = self.desc.get_item("cache_time")
        if (
            cache_time is not None
            and os.path.getmtime(self.get_tag_file()) + cache_time * 24 * 3600
            > time.time()
        ):
            print("skip", str(self.desc.spec) + " due to cache")
            return True

        if new_hash is not None:
            with open(tag_file, "r") as f:
                old_hash = f.read()
            if old_hash == new_hash:
                print("skip", str(self.specification()) + " due to hash")
                return True

        return False

    def build_local(self, action):
        if action == BuildAction.BUILD_WITH_CACHE:
            if self.check_cache():
                return False

        with self.source as source_result:
            # recheck since we change __cbuild_most_recent_tag here
            if action == BuildAction.BUILD_WITH_CACHE:
                if self.check_cache():
                    return False

            script = self.desc.get_script(action)

            if script is None:
                sys.exit("no script for package:" + self.specification().name)

            tmp = script.get_complete_content().splitlines()
            tmp.sort()
            new_hash = self.source.get_checksum() + "-" + str(tmp)

            tag_file = self.get_tag_file()
            if action == BuildAction.BUILD_WITH_CACHE:
                if self.check_cache(new_hash):
                    os.utime(tag_file, (time.time(), time.time()))
                    return False
            features = self.desc.get_features()
            if features:
                print("build", str(self.desc.spec) + " with the following features:")
                for f in features:
                    print("\t{}".format(f))

            build_dir = os.path.join(environment.builds_dir, self.full_name())

            reuse_build = self.desc.get_item("reuse_build", False)
            if not reuse_build:
                shutil.rmtree(build_dir, ignore_errors=True)
            else:
                print("reuse build directory for package:", str(self.desc.spec))
            os.makedirs(build_dir, exist_ok=True)

            if source_result:
                if os.path.isdir(source_result):
                    script.prepend_env_path("SRC_DIR", os.path.abspath(source_result))
                else:
                    script.prepend_env_path(
                        "SRC_DIR", os.path.dirname(os.path.abspath(source_result))
                    )
                    script.prepend_env("FILE_NAME", source_result)
            script.prepend_env_path("BUILD_DIR", build_dir)
            static_analysis_dir = os.path.join(
                environment.static_analysis_dir, self.full_name()
            )
            script.prepend_env_path("STATIC_ANALYSIS_DIR", static_analysis_dir)
            script.append_env("reuse_build", "1" if reuse_build else "0")

            log_file = os.path.join(
                environment.log_dir,
                self.full_name() + ".build.txt",
            )
            os.makedirs(os.path.dirname(log_file), exist_ok=True)
            with open(log_file, "wt", encoding="utf8") as f:
                _, exit_code = script.exec(throw=False, extra_output_files=[f])
                if exit_code != 0:
                    sys.exit("failed to build package:" + self.specification().name)

            with open(tag_file, "w") as f:
                f.write(new_hash)
            if not reuse_build:
                shutil.rmtree(build_dir, ignore_errors=True)
            return True

    def build_docker_image(self, prev_package=None):
        from_docker_image = None
        build_context = BuildContext.get()
        if prev_package is None:
            from_docker_image = self.desc.get_docker_base_image()
            exec_cmd("sudo docker pull " + from_docker_image)
            print("build docker packages in the following context:")
            for ctx in build_context:
                print("\t", ctx)
        else:
            from_docker_image = prev_package.__get_docker_image_name()

        script = self.desc.get_script(BuildAction.DOCKER_BUILD)
        if script is None:
            sys.exit("no script for package:" + self.specification().name)

        docker_src_dir = "~/src"
        build_dir = "~/build"
        script.append_env_path("SRC_DIR", docker_src_dir)
        script.append_env_path("BUILD_DIR", build_dir)
        script.append_env_path("STATIC_ANALYSIS_DIR", "/static_analysis")
        script.prepend_content("mkdir -p " + docker_src_dir)
        script.prepend_content("mkdir -p " + build_dir)
        script.append_content("rm -rf " + build_dir + "/*")
        if "debug_build" not in build_context:
            script.append_content("rm -rf " + docker_src_dir)
        else:
            script.append_content(
                "mkdir -p ~/src_backup && mv "
                + docker_src_dir
                + " /src_backup/"
                + self.full_name(),
            )

        with self.source as source_result:
            src_dir_pair = None
            if source_result:
                if os.path.isdir(source_result):
                    src_dir_pair = (source_result, docker_src_dir)
                else:
                    src_dir_pair = (os.path.dirname(source_result), docker_src_dir)
                    script.append_env(
                        "FILE_NAME",
                        os.path.join(docker_src_dir, os.path.basename(source_result)),
                    )

            additional_docker_commands = []
            if self.desc.get_item("docker_runtime"):
                runtime_path = self.__get_docker_runtime_path()
                with open(runtime_path, "r") as f:
                    additional_docker_commands = f.readlines()
            if prev_package is None:
                for (k, v) in script.env:
                    if k == "INSTALL_PREFIX":
                        additional_docker_commands.append(
                            'ENV INSTALL_PREFIX="' + v + '"'
                        )
                for (k, v) in script.env:
                    if k == "PATH":
                        additional_docker_commands.append(
                            'ENV PATH="' + v + "" + ':$PATH"'
                        )
                    # if k == "PYTHONPATH":
                    #     additional_docker_commands.append(
                    #         'ENV PYTHONPATH="' + v + "" + ':$PYTHONPATH"'
                    #     )
                    if k == "DOCKER_USER":
                        additional_docker_commands.append("USER " + v)

            docker_image_name = self.__get_docker_image_name()
            docker_file = DockerFile(
                from_image=from_docker_image,
                script=script,
                image_name=docker_image_name,
            )
            log_file = os.path.join(
                environment.log_dir,
                "docker_log",
                docker_image_name + ".build.txt",
            )
            os.makedirs(os.path.dirname(log_file), exist_ok=True)
            with open(log_file, "wt") as f:
                _, exit_code = docker_file.build(
                    src_dir_pair=src_dir_pair,
                    additional_docker_commands=additional_docker_commands,
                    docker_ignored_files=[
                        "cbuild_most_recent_git_tag",
                        "script.sh",
                    ],
                    exec_kwargs={"extra_output_files": [f]},
                )
                if exit_code != 0:
                    sys.exit("failed to build docker image of " + docker_image_name)

    def __get_docker_image_name(self):
        tag = self.branch
        if self.specification().features:
            tag += "-" + "-".join(sorted(self.specification().features))
        tag = tag.replace("/", "-")
        return self.name.lower() + ":" + tag[:50]

    def __get_docker_runtime_path(self):
        for branch in [self.branch, "__cbuild_for_all_branches"]:
            script_path = os.path.join(
                self.desc.port_dir(),
                branch,
                "Dockerfile.runtime",
            )
            if os.path.isfile(script_path):
                return script_path
        sys.exit("no docker runtime")

    def __eq__(self, other):
        return self.specification() == other.specification()

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash(self.specification())

    def __repr__(self):
        return repr(self.specification())
