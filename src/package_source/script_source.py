#!/usr/bin/env python3
from .source import Source


class ScriptSource(Source):
    def __init__(self, spec):
        super().__init__(spec)

    def download(self):
        return

    def get_hash(self):
        return "no hash"
