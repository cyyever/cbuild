#!/usr/bin/env python3
import sys
import os

from filelock_git.filelock import FileLock
from ..environment import lock_dir


class Source:
    def __init__(self, spec, url=None, root_dir=None):
        self.spec = spec
        self.url = url
        self.root_dir = root_dir
        self.download_file_path = None
        self.download_dir_path = None
        self.prev_dir = None

    @staticmethod
    def is_git_source(url):
        if url is None:
            return False
        return url.endswith(".git")

    def get_hash(self) -> str:
        raise NotImplementedError

    def _download(self) -> str:
        raise NotImplementedError

    def __enter__(self) -> str:
        self.prev_dir = os.getcwd()
        os.chdir(lock_dir)
        with FileLock(os.path.join(str(self.spec) + ".lock").replace("/", "_")):
            if self.url is not None:
                source_dir = self._download()
                if not source_dir:
                    sys.exit("source is not downloaded")
                return source_dir
            return None

    def __exit__(self, exc_type, exc_value, traceback):
        os.chdir(self.prev_dir)
