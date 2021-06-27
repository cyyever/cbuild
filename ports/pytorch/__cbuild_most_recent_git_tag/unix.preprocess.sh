cd ${SRC_DIR}
${sed_cmd} -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','MKL_INCLUDE_DIR','NCCL_ROOT','GLIBCXX_USE_CXX11_ABI',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e 's/project(Torch CXX C)/project(Torch CXX C ASM)/g' CMakeLists.txt
${sed_cmd} -i -e 's/set(CMAKE_CXX_STANDARD 14)/set(CMAKE_CXX_STANDARD 20)/g' CMakeLists.txt
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e '/-Werror/d' caffe2/CMakeLists.txt
rm -f cmake/Modules/FindOpenMP.cmake
rm -f cmake/Modules/FindOpenBLAS.cmake
rm -f cmake/Modules/Findpybind11.cmake
rm -f cmake/Modules/FindLAPACK.cmake
${sed_cmd} -i -e '/Qunused-arguments/d' CMakeLists.txt
${sed_cmd} -i -e '/-fcolor-diagnostics/d' CMakeLists.txt
${sed_cmd} -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt

if [[ "$(uname)" == "FreeBSD" ]]; then
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
