#!/usr/bin/env python3
import copy
import os
from shutil import which

from cyy_naive_lib.system_info import get_operating_system, get_processor_name


class BuildContext:
    __context_set: set = set()
    __target_system = None

    @staticmethod
    def add(context):
        BuildContext.__context_set.add(context)

    @staticmethod
    def get_host_system():
        return get_operating_system()

    @staticmethod
    def set_target_system(target_system):
        BuildContext.__target_system = target_system

    @staticmethod
    def get_target_system():
        if BuildContext.__target_system is not None:
            return BuildContext.__target_system
        return BuildContext.get_host_system()

    @staticmethod
    def get():
        context_set = copy.deepcopy(BuildContext.__context_set)
        processor_name = get_processor_name().lower()
        if "intel" in processor_name or "amd" in processor_name:
            context_set.add("amd64")
        context_set.add("all_os")
        system = BuildContext.get_target_system()
        context_set.add(system)
        if system != "windows":
            context_set.add("unix")
            if system in ("freebsd", "macos"):
                context_set.add("bsd")
            else:
                context_set.add("linux")
        if "macos" not in context_set:
            if which("nvidia-smi") is not None and (
                "linux" in context_set or "windows" in context_set
            ):
                if "docker" in context_set:
                    if "cuda_docker" in context_set:
                        context_set.add("support_cuda")
                else:
                    context_set.add("support_cuda")
        return context_set


home_dir = os.path.expanduser("~")
project_dir = os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
)
ports_dirs = []
for dir_name in ("ports", "private_ports"):
    ports_dirs.append(os.path.abspath(os.path.join(project_dir, dir_name)))

scripts_dir = os.path.abspath(os.path.join(project_dir, "scripts"))
sources_dir = os.path.abspath(os.path.join(project_dir, ".internal", "sources"))

builds_dir = os.path.abspath(os.path.join(project_dir, ".internal", "builds"))
tag_dir = os.path.abspath(os.path.join(project_dir, ".internal", "tags"))
log_dir = os.path.abspath(os.path.join(project_dir, ".internal", "log"))
static_analysis_dir = os.path.abspath(
    os.path.join(project_dir, ".internal", "static_analysis")
)


for dir_path in [sources_dir, builds_dir, tag_dir, static_analysis_dir]:
    if not os.path.isdir(dir_path):
        os.makedirs(dir_path)
