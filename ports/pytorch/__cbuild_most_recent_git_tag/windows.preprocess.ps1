cd $env:SRC_DIR
sed_cmd -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','MKL_INCLUDE_DIR','NCCL_ROOT',/" tools/setup_helpers/cmake.py
sed_cmd -i -e 's/project(Torch CXX C)/project(Torch CXX C ASM)/g' CMakeLists.txt
sed_cmd -i -e 's/set(CMAKE_CXX_STANDARD 14)/set(CMAKE_CXX_STANDARD 17)/g' CMakeLists.txt
sed_cmd -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
sed_cmd -i -e 's/sizeof(TensorImpl) == sizeof(int64_t) \* 24/true/' c10/core/TensorImpl.h
sed_cmd -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt
rm cmake/Modules/FindLAPACK.cmake
