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
${sed_cmd} -i -e '/CXX_STANDARD 17/d' cmake/public/utils.cmake
${sed_cmd} -i -e 's/-Wmove//g' cmake/public/utils.cmake

if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/_assert/assert_in_pytorch/g' aten/src/ATen/native/sparse/ValidateCompressedIndicesCommon.h
  ${sed_cmd} -i -e 's/ifdef __APPLE__/if 1/g' $(grep 'ifdef __APPLE__' -r torch/csrc -l)
  ${sed_cmd} -i -e 's/py::make_tuple(func, overload_names)/py::make_tuple(func, std::move(overload_names))/g' torch/csrc/jit/python/init.cpp
  ${sed_cmd} -i -e '/..(const std::string. op_name)/s/op_name)/op_name)->py::object/' torch/csrc/jit/python/init.cpp
  ${sed_cmd} -i -e '1834s/kwargs)/kwargs)->py::object/' torch/csrc/jit/python/init.cpp
  git checkout torch/csrc/inductor/aoti_runner/pybind.cpp
  ${sed_cmd} -i -e '/mirror_inductor_external_kernels()$/d' setup.py
fi

if [[ "${BUILD_CONTEXT_macos:=0}" == "0" ]]; then
  ${sed_cmd} -i -e '/set(TP_BUILD_LIBUV ON CACHE BOOL "" FORCE)/s/ON/OFF/g' cmake/Dependencies.cmake
fi

${sed_cmd} -i -e '/codecvt_utf8_utf16/d' c10/util/StringUtil.cpp
${sed_cmd} -i -e '/erter.to_by/s/return .*/return ss;/g' c10/util/StringUtil.cpp
${sed_cmd} -i -e '/has_denorm.*;/d' aten/src/ATen/test/half_test.cpp
${sed_cmd} -i -e '/has_denorm/d' c10/util/*.h
# ${sed_cmd} -i -e '/string(REGEX REPLACE/d' third_party/torch-xpu-ops/cmake/SYCL.cmake
