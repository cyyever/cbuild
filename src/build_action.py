#!/usr/bin/env python3
from enum import Enum, auto


class BuildAction(Enum):
    PREPROCESS = auto()
    BUILD = auto()
    BUILD_WITH_CACHE = auto()
    DOCKER_BUILD = auto()
    AFTER_INSTALL = auto()
