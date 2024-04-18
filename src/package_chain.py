import copy

from cyy_naive_lib.source_code.package_spec import PackageSpecification

from .build_action import BuildAction
from .environment import BuildContext
from .package import Package

PackageSpecification.default_branch = "__cbuild_most_recent_git_tag"


class PackageChain:
    def __init__(self, last_package_specification) -> None:
        self.last_package_specification = last_package_specification
        self.chain: list = []
        self.__get_chain()

    def build(self, action=BuildAction.BUILD_WITH_CACHE, parallel: int = 1) -> None:
        print("build packages in the following context:")
        for ctx in BuildContext.get():
            print("\t", ctx)
        print("build packages in the following order:")
        for pkg in self.chain:
            print("\t", pkg.specification())

        rebuilt_pkgs: set = set()
        for i, cur_pkg in enumerate(self.chain):
            real_action = action
            if real_action == BuildAction.BUILD_WITH_CACHE:
                if i + 1 == len(self.chain) or (
                    not cur_pkg.desc.get_item("cache_ignore_dependency_change", False)
                    and {p.name for p in cur_pkg.desc.get_dependency()}.intersection(
                        rebuilt_pkgs
                    )
                ):
                    real_action = BuildAction.BUILD
                    print("disable cache of", cur_pkg)
            if cur_pkg.build_local(real_action):
                rebuilt_pkgs.add(cur_pkg.name)

    def build_docker(self):
        print("build packages in the following context:")
        for ctx in BuildContext.get():
            print("\t", ctx)
        print("build packages in the following order:")
        for pkg in self.chain:
            print("\t", pkg.specification())

        for i, pkg in enumerate(self.chain):
            prev_pkg = None
            if i > 0:
                prev_pkg = self.chain[i - 1]
            pkg.build_docker_image(prev_pkg)

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
                        sub_chain += f"\t{dep_pkg}\n"
                    sub_chain += "}\n"
                    chain += sub_chain
                raise RuntimeError("detect package dependency loop:" + chain)

            packages.sort(key=lambda x: x.name)
            self.chain += packages
        assert self.chain[-1] == last_package

    def __iter__(self):
        return self.chain.__iter__()

    def __next__(self):
        return self.chain.__next__()
