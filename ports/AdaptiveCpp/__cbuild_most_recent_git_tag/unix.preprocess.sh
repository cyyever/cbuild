cd ${SRC_DIR}


if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/_assert/assert_in_pytorch/g'  HIPSYCL_SSCP_MAP_HOST_FLOAT_BUILTIN(exp10)aten/src/ATen/native/sparse/ValidateCompressedIndicesCommon.h
fi

