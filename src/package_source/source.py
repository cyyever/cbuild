#!/usr/bin/env python3
import os
import sys
from typing import Optional, Tuple

import psutil
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

    def __enter__(self) -> Optional[Tuple[str, Optional[str]]]:
        self.prev_dir = os.getcwd()
        lock_file = os.path.join(lock_dir, str(self.spec).replace("/", "_") + ".lock")
        if os.path.isfile(lock_file):
            with open(lock_file, "rt") as f:
                pid = f.readline().strip()
                if not psutil.pid_exists(pid):
                    print(
                        "no process is using",
                        str(self.spec),
                        ", so remove the lock file",
                    )
                    f.close()
                    os.remove(lock_file)

        with FileLock(lock_file) as lock:
            os.write(lock.fd,bytes(os.getpid()))
            if self.url is not None:
                result = self._download()
                if not result:
                    sys.exit("source is not downloaded")
                source_dir = None
                file_name = None
                if isinstance(result, tuple):
                    (source_dir, file_name) = result
                    file_name = os.path.basename(file_name)
                else:
                    source_dir = result
                return source_dir, file_name
            return None

    def __exit__(self, exc_type, exc_value, traceback):
        os.chdir(self.prev_dir)
