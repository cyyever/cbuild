#!/usr/bin/env python3
from cyy_naive_lib.source_code.source import Source


class ScriptSource(Source):
    def __init__(self, spec, root_dir) -> None:
        super().__init__(spec=spec, root_dir=root_dir)

    def _download(self) -> str:
        return ""

    def get_checksum(self) -> str:
        return "no_checksum"
