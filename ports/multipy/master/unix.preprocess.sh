cd ${SRC_DIR}
${sed_cmd} -i -e "/abi-version/d" multipy/runtime/utils.cmake
${sed_cmd} -i -e "/PYTORCH_ROOT/s#set(PYTORCH_ROOT.*#set(PYTORCH_ROOT ${PYTORCH_ROOT})#" multipy/runtime/utils.cmake
rm -rf build
