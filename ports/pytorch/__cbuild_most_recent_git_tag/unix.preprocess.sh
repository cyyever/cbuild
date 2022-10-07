cd ${SRC_DIR}
${sed_cmd} -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','USE_MEMORY_SANITIZERS','USE_MSAN','USE_TSAN','NO_VPTR','USE_MKLDNN',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e '/Werror/d' third_party/fbgemm/CMakeLists.txt
${sed_cmd} -i -e '/[^:]move/s/move/std::move/g'  third_party/ideep/mkl-dnn/src/utils/pm/pbuilder.cpp
${sed_cmd} -i -e 's/std::std::/std::/g'  third_party/ideep/mkl-dnn/src/utils/pm/pbuilder.cpp
${sed_cmd} -i -e 's/90/11/g' third_party/foxi/CMakeLists.txt
# ${sed_cmd} -i -e 's/CMAKE_CXX_STANDARD 17/CMAKE_CXX_STANDARD 23/g' CMakeLists.txt
if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/_assert/assert_in_pytorch/g' aten/src/ATen/native/sparse/ValidateCompressedIndicesCommon.h
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
