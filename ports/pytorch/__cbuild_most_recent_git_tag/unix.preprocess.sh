cd ${SRC_DIR}
${sed_cmd} -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','USE_ASAN','USE_UBSAN',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e 's/set(CMAKE_CXX_STANDARD 14)/set(CMAKE_CXX_STANDARD 17)/g' CMakeLists.txt
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e 's/sizeof(TensorImpl) == sizeof(int64_t) \* 24/true/' c10/core/TensorImpl.h
${sed_cmd} -i -e '/Werror/d' third_party/fbgemm/CMakeLists.txt
${sed_cmd} -i -e 's/90/11/g' third_party/foxi/CMakeLists.txt
if [[ "$(uname)" == "FreeBSD" ]]; then
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
