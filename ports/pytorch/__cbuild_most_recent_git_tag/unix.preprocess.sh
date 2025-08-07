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

${sed_cmd} -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'USE_NCCL','CMAKE_CXX_STANDARD','CMAKE_CUDA_STANDARD',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e '/ninja/d' requirements.txt
${sed_cmd} -i -e '/cudnn/d' requirements.txt
${sed_cmd} -i -e '/opentelemetry/d' torch/CMakeLists.txt
${sed_cmd} -i -e '/-Wno-pass-failed/s/-Wno-pass-failed/-Wno-pass-failed -Wno-deprecated-literal-operator/' CMakeLists.txt
${sed_cmd} -i -e '/CXX_STANDARD 17/d' cmake/public/utils.cmake

if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/_assert/assert_in_pytorch/g' aten/src/ATen/native/sparse/ValidateCompressedIndicesCommon.h
fi

if [[ "${BUILD_CONTEXT_macos:=0}" == "0" ]]; then
  ${sed_cmd} -i -e '/set(TP_BUILD_LIBUV ON CACHE BOOL "" FORCE)/s/ON/OFF/g' cmake/Dependencies.cmake
fi

${sed_cmd} -i -e '/codecvt_utf8_utf16/d' c10/util/StringUtil.cpp
${sed_cmd} -i -e '/erter.to_by/s/return .*/return ss;/g' c10/util/StringUtil.cpp
${sed_cmd} -i -e '/has_denorm.*;/d' aten/src/ATen/test/half_test.cpp
${sed_cmd} -i -e '/has_denorm/d' c10/util/*.h
