#!/usr/bin/env python3
import os
import sys
from tqdm import tqdm
import requests

from naive_lib.cyy_naive_lib.algorithm.hash import file_hash

from .source import Source


class FileSource(Source):
    def __init__(self, spec, url, root_dir, file_name, checksum):
        super().__init__(spec, url, root_dir)
        self.file_name = file_name
        self.checksum = checksum
        if not self.checksum:
            sys.exit("no checksum for " + self.file_name + "consider add one")
        self._file_path = os.path.join(root_dir, self.file_name)

    def get_hash(self) -> str:
        return self.checksum

    def _download(self) -> str:
        if not os.path.isfile(self._file_path):
            print("downloading", self.file_name)
            os.chdir(self.root_dir)

            response = requests.get(self.url, stream=True)
            with open(self.file_name, "wb") as f:
                total_length = response.headers.get("content-length")
                if total_length is None:
                    sys.exit(
                        "download failed for "
                        + self.file_name
                        + " content-length is None"
                    )
                for chunk in tqdm(
                    response.iter_content(chunk_size=1024 * 1024),
                    total=int(total_length) / (1024 * 1024),
                    unit="mb",
                ):
                    if chunk:
                        f.write(chunk)
                f.flush()

            if response.status_code != 200:
                sys.exit(
                    "download failed for "
                    + self.file_name
                    + " status_code:"
                    + str(response.status_code)
                )

        if self.checksum == "no_checksum":
            return os.path.dirname(self._file_path)
        verify_checksum = False
        for checksum_prefix in ["md5", "sha256"]:
            if self.checksum.startswith(checksum_prefix + ":"):
                if (
                    file_hash(self._file_path, checksum_prefix)
                    != self.checksum[len(checksum_prefix) + 1:]
                ):
                    os.remove(self._file_path)
                    sys.exit(
                        "wrong checksum for " +
                        self.file_name +
                        ", so we delete " +
                        self._file_path +
                        ", you should re-run this script to re-download this package")
                else:
                    verify_checksum = True
                    break
        if not verify_checksum:
            sys.exit("unknown checksum format for " + self.file_name)
        return os.path.dirname(self._file_path)
