cd ${SRC_DIR}
if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/if defined(__apple_build_version__)/if 1/g' include/pybind11/detail/common.h
fi
