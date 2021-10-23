#!/usr/bin/env python3
import re
import sys
from distutils.version import StrictVersion


class PackageSpecification:
    @staticmethod
    def compare_version(ver1: str, ver2: str) -> int:
        if ver1 in ("master", "main"):
            if ver2 in ("master", "main"):
                return 0
            return 1

        if ver2 in ("master", "main"):
            return -1

        if ver1.startswith("v"):
            ver1 = ver1[1:]
        if ver2.startswith("v"):
            ver2 = ver2[1:]

        if StrictVersion(ver1) < StrictVersion(ver2):
            return -1
        if StrictVersion(ver1) > StrictVersion(ver2):
            return 1
        return 0

    def __init__(self, specification):
        match_res = re.match(
            "^([a-zA-Z0-9_-]+)(\\[(.*)\\])?(:[a-zA-Z0-9_./-]+)?$", specification
        )
        if match_res is None:
            sys.exit("unsupported package specification:" + specification)

        self.name = match_res.group(1)
        self.features = match_res.group(3)
        self.branch = match_res.group(4)
        if self.branch:
            self.branch = self.branch[1:]
        else:
            self.branch = "__cbuild_most_recent_git_tag"
        if self.features is not None:
            self.features = set(self.features.split(","))
        else:
            self.features = set()

    def __repr__(self):
        res = self.name
        if self.features:
            res += "[" + ",".join(sorted(list(self.features))) + "]"
        return res + ":" + self.branch

    def __eq__(self, other):
        return self.name == other.name and self.branch == other.branch

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash((self.name, self.branch))
