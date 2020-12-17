#!/usr/bin/env python3
import copy
from .package import Package
from .package_spec import PackageSpecification
from .package_description import PackageDescription
from .environment import BuildContext


class PackageChain:
    def __init__(self, last_package_specification):
        self.last_package_specification = last_package_specification
        self.chain = []
        self.__get_chain()

    def build(self, action=PackageDescription.BuildAction.BUILD_WITH_CACHE):
        print("build packages in the following context:")
        for ctx in BuildContext.get():
            print("\t", ctx)
        print("build packages in the following order:")
        for pkg in self.chain:
            print("\t", pkg.specification())

        rebuilt_pkgs = set()
        for i, pkg in enumerate(self.chain):
            prev_pkg = None
            if i > 0:
                prev_pkg = self.chain[i - 1]

            real_action = action
            cur_pkg = self.chain[i]
            if real_action == PackageDescription.BuildAction.BUILD_WITH_CACHE and (
                i + 1 == len(self.chain)
                or {p.name for p in cur_pkg.desc.get_dependency()}.intersection(
                    rebuilt_pkgs
                )
            ):
                real_action = PackageDescription.BuildAction.BUILD
                print("disable cache of", cur_pkg)
            if cur_pkg.build(real_action, prev_pkg):
                rebuilt_pkgs.add(cur_pkg.name())

    def __get_chain(self):
        package_dependency = {}
        last_package_specification = self.last_package_specification
        if not isinstance(last_package_specification, PackageSpecification):
            last_package_specification = PackageSpecification(
                last_package_specification
            )
        last_package = Package(last_package_specification)
        to_check_packages = [last_package]
        while to_check_packages:
            cur_package = to_check_packages.pop(0)
            if cur_package not in package_dependency:
                package_dependency[cur_package] = set()
            for next_package_spec in cur_package.desc.get_dependency():
                next_package = Package(next_package_spec)
                package_dependency[cur_package].add(next_package)
                if next_package not in package_dependency:
                    to_check_packages.append(next_package)

        while package_dependency:
            for dep_set in package_dependency.values():
                for determined_package in self.chain:
                    if determined_package in dep_set:
                        dep_set.remove(determined_package)

            packages = []

            for cur_package in copy.deepcopy(package_dependency):
                if package_dependency[cur_package]:
                    continue
                packages.append(cur_package)

                del package_dependency[cur_package]

            if not packages:
                chain = ""
                for pkg, dep_set in package_dependency.items():
                    sub_chain = str(pkg) + "=>{\n"
                    for dep_pkg in dep_set:
                        sub_chain += "\t{}\n".format(str(dep_pkg))
                    sub_chain += "}\n"
                    chain += sub_chain
                raise RuntimeError("detect package dependency loop:" + chain)

            packages.sort(key=lambda x: x.name())
            self.chain += packages
        assert self.chain[-1] == last_package
        if self.chain[0].name() != "OS":
            self.chain.insert(0, Package(PackageSpecification("OS:main")))

    def __iter__(self):
        return self.chain.__iter__()

    def __next__(self):
        return self.chain.__next__()
