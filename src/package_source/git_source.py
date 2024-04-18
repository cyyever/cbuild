import functools
import os
import re
import sys

from cyy_naive_lib.shell import exec_cmd
from cyy_naive_lib.source_code.package_spec import PackageSpecification
from cyy_naive_lib.source_code.source import Source
from cyy_naive_lib.storage import persistent_cache
from cyy_naive_lib.system_info import OSType, get_operating_system_type
from looseversion import LooseVersion



class GitSource(Source):
    @staticmethod
    def is_git_source(git_url) -> bool:
        if git_url is None:
            return False
        return git_url.endswith(".git") or git_url.startswith("git://")

    def __init__(
        self,
        spec: PackageSpecification,
        git_url: str,
        root_dir: str,
        with_submodule: bool = True,
        remote_url: str | None = None,
        remote_branch: str | None = None,
        ignored_submodules: list | None = None,
        ignored_tag_regex: list | None = None,
    ) -> None:
        super().__init__(spec=spec, root_dir=root_dir)
        if not GitSource.is_git_source(git_url):
            sys.exit("no git url:" + git_url)
        self.url = git_url
        self.__repositary_path = os.path.join(
            root_dir, self.url.split("/")[-1].replace(".git", "")
        )
        self.remote_url = remote_url
        self.remote_branch = remote_branch
        self.with_submodule = with_submodule
        self.ignored_submodules = ignored_submodules
        self.ignored_tag_regex = ignored_tag_regex

    def get_checksum(self) -> str:
        with self:
            commit_hash, _ = exec_cmd("git rev-parse HEAD")
            if commit_hash is None:
                sys.exit("git rev-parse failed")
            return commit_hash.strip()

    @functools.cache
    def _download(self) -> str:
        print("downloading", self.spec.name)
        if not os.path.isdir(os.path.join(self.__repositary_path, ".git")):
            if os.path.exists(self.__repositary_path):
                if not os.listdir(self.__repositary_path):
                    os.rmdir(self.__repositary_path)
                else:
                    sys.exit(
                        self.__repositary_path + " exists but not a git repository"
                    )

            os.makedirs(self.__repositary_path, exist_ok=True)
            os.chdir(self.__repositary_path)
            exec_cmd("git init")
            exec_cmd("git remote add origin " + self.url)
            if self.remote_url is not None:
                exec_cmd("git remote add up " + self.remote_url)
        os.chdir(self.__repositary_path)
        if self.spec.branch == PackageSpecification.default_branch:
            tag = self.__get_max_tag()
            if tag is not None:
                self.spec.branch = tag
            else:
                default_branch = self.__get_default_branch()
                assert default_branch is not None
                self.spec.branch = default_branch
            print("resolve spec", self.spec.name, "to branch", self.spec.branch)
        if not os.getenv("no_update_pkg"):
            exec_cmd("git clean -fxd :/")
            exec_cmd("git restore .", throw=False)
            exec_cmd("git submodule foreach git restore .", throw=False)
        if self.remote_url is not None:
            assert self.remote_branch is not None
            exec_cmd("git fetch origin " + self.spec.branch)
            if not os.getenv("no_update_pkg"):
                exec_cmd("git reset --hard FETCH_HEAD")
            exec_cmd("git fetch up " + self.remote_branch)

            _, error_code = exec_cmd("git rebase up/" + self.remote_branch, throw=False)
            if error_code != 0:
                print("disable rebase")
                exec_cmd("git rebase --abort")
            else:
                print("rebase succ")
        else:
            exec_cmd("git fetch --depth 1 origin " + self.spec.branch)
            if not os.getenv("no_update_pkg"):
                exec_cmd("git reset --hard FETCH_HEAD")

        if self.with_submodule:
            exec_cmd("git submodule sync")

            cmd = "git "
            if self.ignored_submodules:
                for submodel in self.ignored_submodules:
                    if get_operating_system_type() == OSType.Windows:
                        cmd += "-c submodule." + submodel + ".update=none "
                    else:
                        cmd += '-c submodule."' + submodel + '".update=none '
            cmd += " submodule update --init --recursive"
            exec_cmd(cmd)

        print("finish downloading", self.spec.name)
        return self.__repositary_path

    def in_master(self):
        return self.spec.branch in ("master", "main")

    @persistent_cache(path="__default_branch", cache_time=3600)
    def __get_default_branch(self) -> None | str:
        branches, exit_code = exec_cmd(cmd="git branch -r", throw=False)
        if exit_code != 0:
            return None
        for branch in branches.strip().splitlines():
            print("check branch", branch)
            if "origin" not in branch:
                continue
            for candidate in ["origin/main", "origin/master"]:
                if branch == candidate:
                    return branch.split("/")[-1]
        return None

    @persistent_cache(path="__max_tag", cache_time=3600)
    def __get_max_tag(self) -> None | str:
        exec_cmd("git fetch origin --depth 1 --tags -f")
        tags, exit_code = exec_cmd(
            cmd="git describe --tags $(git rev-list --tags --max-count=10)", throw=False
        )
        if exit_code != 0:
            return None
        tags = tags.strip().splitlines()

        tags = [t for t in tags if re.search("rc([0-9]*)$", t) is None]
        tags = [t for t in tags if re.search("RC([0-9]*)$", t) is None]
        tags = [t for t in tags if re.search("b([0-9]+)$", t) is None]
        tags = [t for t in tags if re.search("beta", t) is None]
        tags = [t for t in tags if re.search("dev", t) is None]
        tags = [t for t in tags if re.search("alpha", t) is None]
        tags = [t for t in tags if re.search("before", t) is None]
        tags = [t for t in tags if re.search("pre", t) is None]
        if self.ignored_tag_regex is not None:
            for regex in self.ignored_tag_regex:
                tags = [t for t in tags if re.search(regex, t) is None]
        tags = [tag for tag in tags if tag]
        print("final tags", tags)
        tag = tags[0]
        try:
            tags = sorted(tags, key=LooseVersion)
            tag = tags[-1]
        except BaseException as e:
            print("get exception", e, "and use first tag", tag)
        print("use tag", tag)
        return tag
