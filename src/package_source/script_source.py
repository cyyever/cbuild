#!/usr/bin/env python3
from cyy_naive_lib.source_code.source import Source


class ScriptSource(Source):
    def __init__(self, spec, root_dir):
        super().__init__(spec=spec, root_dir=root_dir)

    def _download(self):
        return ""

    def get_checksum(self):
        return "no_checksum"
