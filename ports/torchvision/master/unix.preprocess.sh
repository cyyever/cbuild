if [[ "$(uname)" == "FreeBSD" ]]; then
  cd ${SRC_DIR}
  ${sed_cmd} -i -e "s/ENODATA/ENOATTR/g" torchvision/csrc/cpu/decoder/sync_decoder.cpp
  ${sed_cmd} -i -e "s/ENODATA/ENOATTR/g" torchvision/csrc/cpu/decoder/decoder.cpp
fi
