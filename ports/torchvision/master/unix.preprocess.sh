cd ${SRC_DIR}
if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e "s/ENODATA/ENOATTR/g" torchvision/csrc/cpu/decoder/sync_decoder.cpp
  ${sed_cmd} -i -e "s/ENODATA/ENOATTR/g" torchvision/csrc/cpu/decoder/decoder.cpp
fi
${sed_cmd} -i -e "s/image_link_flags.append('jpeg')/image_link_flags.append('turbojpeg')/g" setup.py
${sed_cmd} -i -e "s#include_dirs=image_include#include_dirs=\[\"$INSTALL_PREFIX/include\"\]+image_include#g" setup.py
${sed_cmd} -i -e "s#library_dirs=image_library#library_dirs=\[\"$INSTALL_PREFIX/lib64\"\]+library_dirs#g" setup.py
