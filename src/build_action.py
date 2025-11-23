from enum import StrEnum, auto


class BuildAction(StrEnum):
    PREPROCESS = auto()
    BUILD = auto()
    BUILD_WITH_CACHE = auto()
    DOCKER_BUILD = auto()
    AFTER_INSTALL = auto()
