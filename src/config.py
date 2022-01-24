#!/usr/bin/env python3
import json
import multiprocessing
import os
from typing import Callable

from cyy_naive_lib.algorithm.sequence_op import flatten_list

from .environment import project_dir


class ToolMapping:
    def __init__(self):
        with open(os.path.join(project_dir, "config", "tool_mapping.json"), "r") as f:
            self.data: dict = json.load(f)

    def guess_language(self, lines):
        tokens = set()
        if isinstance(lines, str):
            lines = lines.splitlines()
        for line in lines:
            line_tokens = line.split()
            tokens.update(line_tokens)
        tools = tokens.intersection(self.data.keys())
        languages = []
        for tool in tools:
            languages += self.data[tool]
        return (tools, set(languages))

    def get_languages(self, tool):
        return self.data.get(tool, [])

    def is_supported_language(self, lang):
        return lang in set(sum(self.data.values(), []))

    def is_supported_tool(self, tool):
        return tool in self.data


class Config:
    def __init__(self, local_config_chain: list = None, global_config_path: str = None):
        self.config_chain = []
        if local_config_chain is not None:
            self.config_chain = local_config_chain
        if global_config_path is None:
            global_config_path = os.path.join(project_dir, "config", "global.json")
        with open(global_config_path, "r", encoding="utf-8") as f:
            self.config_chain.append(json.load(f))
        if not self.config_chain:
            raise RuntimeError("configuration chain is empty")

    def set(self, key: str, value: str) -> None:
        self.config_chain[0][key] = value

    def get(self, key: str, default=None):
        for config in self.config_chain:
            if key in config:
                return config[key]
        return default

    def conditional_get(
        self, key: str, check_fn: Callable, global_to_local=False
    ) -> list:
        values = []
        chain = self.config_chain
        if global_to_local:
            chain = list(reversed(chain))
        for config in chain:
            if key in config:
                values.append(config[key])
            for k in [
                "conditional_" + key,
                "context_" + key,
            ]:
                if k not in config:
                    continue
                for cond, value in config[k].items():
                    if check_fn(cond):
                        values.append(value)
        return values


class Environment:
    def __init__(
        self,
        local_config_chain: list = None,
    ):
        self.config = Config(
            local_config_chain=local_config_chain,
            global_config_path=os.path.join(project_dir, "config", "env.json"),
        )

    def get(self, check_fn: Callable):
        environment_variables = self.config.conditional_get(
            "base_environment_variable", check_fn
        ) + self.config.conditional_get(
            "environment_variable", check_fn, global_to_local=True
        )
        return ["CPU_COUNT=" + str(multiprocessing.cpu_count())] + flatten_list(
            environment_variables
        )
