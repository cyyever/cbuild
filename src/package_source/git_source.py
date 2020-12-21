#!/usr/bin/env python3
import os
import re
import sys
import time
from distutils.version import LooseVersion

from naive_lib.cyy_naive_lib.shell_factory import exec_cmd
from naive_lib.cyy_naive_lib.util import readlines

from .source import Source


class GitSource(Source):
    @staticmethod
    def is_git_source(git_url):
        if git_url is None:
            return False
        return git_url.endswith(".git")

    def __init__(
        self,
        spec,
        git_url: str,
        root_dir: str,
        with_submodule=True,
        ignored_submodules=None,
        ignored_tag_regex=None,
    ):
        super().__init__(spec, git_url, root_dir)
        if not GitSource.is_git_source(git_url):
            sys.exit("no git url:" + git_url)
        self.__repositary_path = os.path.join(
            root_dir, self.url.split("/")[-1].replace(".git", "")
        )
        self.with_submodule = with_submodule
        self.ignored_submodules = ignored_submodules
        self.ignored_tag_regex = ignored_tag_regex

    def get_hash(self) -> str:
        with self:
            commit_hash, _ = exec_cmd("git rev-parse HEAD")
            if commit_hash is None:
                sys.exit("git rev-parse failed")
            return commit_hash.strip()

    def _download(self) -> str:
        print("downloading", self.spec.name)
        if not os.path.isdir(os.path.join(self.__repositary_path, ".git")):
            if os.path.exists(self.__repositary_path):
                if not os.listdir(self.__repositary_path):
                    os.rmdir(self.__repositary_path)
                else:
                    sys.exit(
                        self.__repositary_path +
                        " exists but not a git repository")

            os.makedirs(self.__repositary_path, exist_ok=True)
            os.chdir(self.__repositary_path)
            exec_cmd("git init")
            exec_cmd("git remote add origin " + self.url)
        os.chdir(self.__repositary_path)
        if self.spec.branch == "__cbuild_most_recent_git_tag":
            self.spec.branch = self.__get_max_tag()
            print(
                "resolve spec",
                self.spec.name,
                "to branch",
                self.spec.branch)

        exec_cmd("git fetch --depth 1 origin " + self.spec.branch)
        exec_cmd("git reset --hard FETCH_HEAD")

        if self.with_submodule:
            exec_cmd("git submodule sync")

            cmd = "git "
            if self.ignored_submodules:
                for submodel in self.ignored_submodules:
                    cmd += '-c submodule."' + submodel + '".update=none '
            cmd += " submodule update --init --recursive"
            exec_cmd(cmd)

        print("finish downloading", self.spec.name)
        return self.__repositary_path

    def in_master(self):
        return self.spec.branch.lower() in ("master", "main")

    def __get_max_tag(self):
        cache_file = "__cbuild_most_recent_git_tag"
        if os.path.isfile(cache_file) and time.time() < 3600 * \
                24 + os.path.getmtime(cache_file):
            return readlines(cache_file)[0].strip()

        exec_cmd("git fetch origin --depth 1 --tags -f")
        tags, _ = exec_cmd(
            "git describe --tags $(git rev-list --tags --max-count=10)")
        if tags is None:
            sys.exit("get max tag failed")
        tags = tags.strip().splitlines()

        tags = [t for t in tags if re.search("rc([0-9]+)$", t) is None]
        tags = [t for t in tags if re.search("b([0-9]+)$", t) is None]
        tags = [t for t in tags if re.search("beta", t) is None]
        if self.ignored_tag_regex is not None:
            for regex in self.ignored_tag_regex:
                tags = [t for t in tags if re.search(regex, t) is None]

        print("final tags", tags)
        tag = tags[0]
        try:
            tags = sorted(tags, key=LooseVersion)
            tag = tags[-1]
        except BaseException as e:
            print("get exception", e, "and use first tag", tag)
        print("use tag", tag)
        open(cache_file, "wt").write(tag)
        return tag
