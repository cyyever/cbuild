cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/lib/libc10* || true
rm -rf ${INSTALL_PREFIX}/lib/libtorch* || true
rm -rf ${INSTALL_PREFIX}/lib/libshm* || true
rm -rf ${INSTALL_PREFIX}/lib/libcaffe2* || true
rm -rf ${INSTALL_PREFIX}/include/torch || true
rm -rf ${INSTALL_PREFIX}/include/ATen || true
rm -rf ${INSTALL_PREFIX}/include/c10 || true
rm -rf ${INSTALL_PREFIX}/include/caffe2 || true
rm -rf ${INSTALL_PREFIX}/include/sleef.h || true
rm -rf ${INSTALL_PREFIX}/include/xnnpack.h || true
${sed_cmd} -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'USE_NCCL','CMAKE_CXX_STANDARD','CMAKE_CUDA_STANDARD','FBGEMM_SOURCE_DIR'/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e '/int64_t max_split_size/s/int64_t/size_t/g' c10/cuda/CUDACachingAllocator.h
${sed_cmd} -i -e '/ninja/d' requirements.txt
${sed_cmd} -i -e '/cudnn/d' requirements.txt
${sed_cmd} -i -e '/Werror/d' third_party/fbgemm/CMakeLists.txt
${sed_cmd} -i -e '/opentelemetry/d' torch/CMakeLists.txt
${sed_cmd} -i -e '/-Wno-pass-failed/s/-Wno-pass-failed/-Wno-pass-failed -Wno-deprecated-literal-operator/' CMakeLists.txt
${sed_cmd} -i -e '/CXX_STANDARD 17/d' cmake/public/utils.cmake
${sed_cmd} -i -e '/CONVERT_NON_VECTORIZED_INIT(BFloat16, bfloat16);/s/CONVERT_NON_VECTORIZED_INIT(BFloat16, bfloat16);/CONVERT_NON_VECTORIZED_INIT(BFloat16, bfloat16)/g' aten/src/ATen/cpu/vec/vec256/vec256_bfloat16.h

if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/_assert/assert_in_pytorch/g' aten/src/ATen/native/sparse/ValidateCompressedIndicesCommon.h
  ${sed_cmd} -i -e '/defined(__APPLE__)/s/defined(__APPLE__).*/1/g' third_party/onnx/onnx/checker.cc
fi

if [[ "${BUILD_CONTEXT_macos:=0}" == "0" ]]; then
  ${sed_cmd} -i -e '/set(TP_BUILD_LIBUV ON CACHE BOOL "" FORCE)/s/ON/OFF/g' cmake/Dependencies.cmake
fi

${sed_cmd} -i -e 's/value_.template /value_./g' third_party/tensorpipe/third_party/libnop/include/nop/types/variant.h
