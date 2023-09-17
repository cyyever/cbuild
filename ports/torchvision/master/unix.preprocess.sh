cd ${SRC_DIR}
${sed_cmd} -i -e "/PILLOW_VERSION = /d" test/*py
${sed_cmd} -i -e "s/if PILLOW_VERSION >[^)]*)/if True/" test/*py
${sed_cmd} -i -e "s/c10::to_string/std::to_string/" torchvision/csrc/io/video/video.cpp
${sed_cmd} -i -e "s/c10::stoi/std::stoi/" torchvision/csrc/io/video/video.cpp
rm -rf build
