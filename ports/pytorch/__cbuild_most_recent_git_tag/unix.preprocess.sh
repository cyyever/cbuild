cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/lib/libc10* || true
rm -rf ${INSTALL_PREFIX}/lib/libtorch* || true
rm -rf ${INSTALL_PREFIX}/lib/libcaffe2* || true
rm -rf ${INSTALL_PREFIX}/include/torch || true
${sed_cmd} -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'CUDA_USE_STATIC_CUDA_RUNTIME', 'CAFFE2_USE_MKL','USE_NCCL',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e '/finalAtom/s/, pos . startSearchFrom//g' aten/src/ATen/core/qualified_name.h
if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/_assert/assert_in_pytorch/g' aten/src/ATen/native/sparse/ValidateCompressedIndicesCommon.h
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
