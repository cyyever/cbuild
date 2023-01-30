cd ${SRC_DIR}
# ${sed_cmd} -i -e 's/image_link_flags.append("jpeg")/image_link_flags.append("turbojpeg")/g' setup.py
${sed_cmd} -i -e "/PILLOW_VERSION = /d" test/*py
# ${sed_cmd} -i -e "/affine_quantizer.h/d" torchvision/csrc/ops/quantized/cpu/qnms_kernel.cpp
${sed_cmd} -i -e "s/if PILLOW_VERSION >[^)]*)/if True/" test/*py
rm -rf build
