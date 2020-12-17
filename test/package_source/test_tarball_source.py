from naive_lib.cyy_naive_lib.fs.tempdir import TempDir

from src.package_source.tarball_source import TarballSource
from src.package_spec import PackageSpecification


def test_git_source():
    with TempDir():
        spec = PackageSpecification("bibclean:2.17")
        source = TarballSource(
            spec,
            "http://ftp.math.utah.edu/pub/bibclean/bibclean-2.17-windows.zip",
            ".",
            "bibclean-2.17-windows.zip",
            "sha256:6ad589429ab8954cc7ea395f16d26ae38031bb478cf8ac678721c88b97e76687",
        )
        with source:
            pass
