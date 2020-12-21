#!/usr/bin/env python3
import os
import shutil
import sys
import zipfile

from src import environment
from naive_lib.cyy_naive_lib.shell_factory import exec_cmd
from naive_lib.cyy_naive_lib.fs.tempdir import TempDir
from .file_source import FileSource


class TarballSource(FileSource):
    def __init__(self, spec, url, root_dir, file_name, checksum=None):
        super().__init__(spec, url, root_dir, file_name, checksum)
        self.suffix = None
        for suffix in [
            ".zip",
            ".tar",
            ".tar.gz",
            ".tar.xz",
            ".tar.bz2",
                ".tgz"]:
            if self.file_name.endswith(suffix):
                self.suffix = suffix

        if self.suffix is None:
            raise TypeError("no tarball url:" + self.url)

    def _download(self) -> str:
        super()._download()
        return self.__extract()

    def __extract(self) -> str:
        if not self._file_path:
            sys.exit("please download " + self.file_name + " before extract")

        tarball_dir = os.path.join(
            environment.sources_dir,
            self.spec.name + "_" + self.checksum.replace(":", "-"),
        )
        if os.path.isdir(tarball_dir):
            shutil.rmtree(tarball_dir)

        os.makedirs(tarball_dir)
        print("extracting", self.file_name)
        try:
            with TempDir():
                if self.suffix == ".zip":
                    with zipfile.ZipFile(self._file_path, "r") as myzip:
                        myzip.extractall()
                else:
                    exec_cmd("tar -xf " + self._file_path)
                exec_cmd("mv * " + tarball_dir)
                return tarball_dir
        except Exception as e:
            if os.path.isdir(tarball_dir):
                shutil.rmtree(tarball_dir)
            sys.exit("extracting " + self.file_name + " failed:" + str(e))
        return None
