#!/usr/bin/env python3
# import copy
import os
import shutil
import sys
import time

from naive_lib.cyy_naive_lib.shell.docker_file import DockerFile

from . import environment
from .environment import BuildContext
from .package_description import PackageDescription


class Package:
    def __init__(self, specification):
        self.desc = PackageDescription(specification)
        self.source = self.desc.get_source()

    def name(self):
        return self.desc.spec.name

    def branch(self):
        return self.desc.spec.branch

    def full_name(self):
        return self.name() + "-" + self.branch()

    def specification(self):
        return self.desc.spec

    def build(self, action=PackageDescription.BuildAction.BUILD, prev_package=None):

        if action in (
            PackageDescription.BuildAction.BUILD,
            PackageDescription.BuildAction.BUILD_WITH_CACHE,
        ):
            return self.__build_local(action)
        if action == PackageDescription.BuildAction.DOCKER_BUILD:
            return self.build_docker_image(action, prev_package)
        sys.exit("unknown action")

    def get_tag_file(self):
        return os.path.join(
            environment.tag_dir, (self.full_name() + ".tag").replace("/", "_")
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
            old_hash = open(tag_file, "r").read()
            if old_hash == new_hash:
                print("skip", str(self.specification()) + " due to hash")
                return True

        return False

    def __build_local(self, action):
        if action == PackageDescription.BuildAction.BUILD_WITH_CACHE:
            if self.check_cache():
                return False

        with self.source as source_result:
            # recheck since we change __cbuild_most_recent_tag here
            if action == PackageDescription.BuildAction.BUILD_WITH_CACHE:
                if self.check_cache():
                    return False

            script = self.desc.get_script(action)

            if script is None:
                sys.exit("no script for package:" + self.specification().name)

            tmp = script.get_complete_content().splitlines()
            tmp.sort()
            new_hash = self.source.get_hash() + "-" + str(tmp)

            tag_file = self.get_tag_file()
            if action == PackageDescription.BuildAction.BUILD_WITH_CACHE:
                if self.check_cache(new_hash):
                    os.utime(tag_file, (time.time(), time.time()))
                    return False
            features = self.desc.get_features()
            if features:
                print("build", str(self.desc.spec) + " with the following features:")
                for f in features:
                    print("\t{}".format(f))

            build_dir = os.path.join(environment.builds_dir, self.full_name())
            shutil.rmtree(build_dir, ignore_errors=True)
            os.makedirs(build_dir)
            static_analysis_dir = os.path.join(
                environment.static_analysis_dir, self.full_name()
            )
            shutil.rmtree(static_analysis_dir, ignore_errors=True)
            os.makedirs(static_analysis_dir)

            if source_result is not None:
                src_dir, file_name = source_result
                script.prepend_env("SRC_DIR", os.path.abspath(src_dir))
                if file_name:
                    script.prepend_env("FILE_NAME", file_name)
            script.prepend_env("BUILD_DIR", build_dir)
            script.prepend_env("STATIC_ANALYSIS_DIR", static_analysis_dir)
            output, exit_code = script.exec(throw=False)

            log_file = os.path.join(
                environment.log_dir,
                self.full_name() + ".build.txt",
            )
            os.makedirs(os.path.dirname(log_file), exist_ok=True)
            if os.path.isfile(log_file):
                os.remove(log_file)
            with open(log_file, "wt", encoding="utf8") as f:
                f.write(output)

            if exit_code != 0:
                sys.exit("failed to build package:" + self.specification().name)

            with open(tag_file, "w") as f:
                f.write(new_hash)
            shutil.rmtree(build_dir, ignore_errors=True)
            return True

    def build_docker_image(self, action, prev_package=None):
        from_docker_image = None
        build_context = BuildContext.get()
        if prev_package is None:
            from_docker_image = self.desc.get_docker_base_image()
            print("build docker packages in the following context:")
            for ctx in build_context:
                print("\t", ctx)
        else:
            from_docker_image = prev_package.__get_docker_image_name()

        script = self.desc.get_script(action)
        if script is None:
            sys.exit("no script for package:" + self.specification().name)

        src_dir = "/src"
        build_dir = "/build"
        script.append_env("SRC_DIR", src_dir)
        script.append_env("BUILD_DIR", build_dir)
        script.prepend_content("mkdir -p " + build_dir)
        script.prepend_content("mkdir -p " + src_dir)
        script.append_content("rm -rf " + build_dir)
        if "debug_build" not in build_context:
            script.append_content("rm -rf " + src_dir)
        else:
            script.append_content(
                "mkdir -p /src_backup && mv "
                + src_dir
                + " /src_backup/"
                + self.full_name(),
            )

        with self.source as source_result:
            if source_result:
                file_name = source_result[1]
                if file_name:
                    script.append_env("FILE_NAME", file_name)

            addtional_docker_commands = None
            if self.desc.get_item("docker_runtime"):
                runtime_path = self.__get_docker_runtime_path()
                if not runtime_path:
                    sys.exit("no docker runtime")
                addtional_docker_commands = open(runtime_path, "r").readlines()
            docker_file = DockerFile(from_image=from_docker_image, script=script)
            output, exit_code = docker_file.build(
                result_image=self.__get_docker_image_name(),
                src_dir=src_dir,
                additional_docker_commands=addtional_docker_commands,
            )

            docker_image_name = self.__get_docker_image_name()
            log_file = os.path.join(
                environment.log_dir,
                "succ_docker_log" if exit_code == 0 else "fail_docker_log",
                environment.date_str,
                docker_image_name + ".build.txt",
            )
            os.makedirs(os.path.dirname(log_file), exist_ok=True)
            if os.path.isfile(log_file):
                os.remove(log_file)
            with open(log_file, "wt") as f:
                f.write(output)
            if exit_code != 0:
                sys.exit("failed to build docker image of " + docker_image_name)

    def __get_docker_image_name(self):
        docker_image_name = self.name().lower() + ":" + self.specification().branch
        if self.specification().features:
            docker_image_name += "-" + "-".join(sorted(self.specification().features))
        return docker_image_name.replace("/", "-")

    def __get_docker_runtime_path(self):
        for branch in [self.branch(), "__cbuild_for_all_branches"]:
            script_path = os.path.join(
                self.desc.port_dir(),
                branch,
                "Dockerfile.runtime",
            )
            if os.path.isfile(script_path):
                return script_path
        return None

    def __eq__(self, other):
        return self.specification() == other.specification()

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash(self.specification())

    def __str__(self):
        return str(self.specification())
