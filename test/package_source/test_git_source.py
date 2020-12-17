from naive_lib.cyy_naive_lib.fs.tempdir import TempDir

from src.package_source.git_source import GitSource
from src.package_spec import PackageSpecification


def test_git_source():
    with TempDir():
        git_url = "git@github.com:microsoft/GSL.git"
        source = GitSource(PackageSpecification(
            "GSL:__cbuild_most_recent_git_tag"), git_url, ".")
        with source:
            pass
