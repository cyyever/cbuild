cd "$env:SRC_DIR"
sed -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'CUDA_USE_STATIC_CUDA_RUNTIME', 'CAFFE2_USE_MKL','USE_NCCL',/" tools/setup_helpers/cmake.py
sed -i -e '/^ *check_submodules()/d' setup.py
rm  cmake/Modules/FindMKL.cmake
sed -i -e "/MKL_INCLUDE_DIR/s/MKL_INCLUDE_DIR/MKL_INCLUDE/g"  cmake/public/mkl.cmake
sed -i -e "/target_link_libraries/s/..MKL_LIBRARIES./MKL::MKL/g"  cmake/public/mkl.cmake
sed -i -e "/MKL_INCLUDE_DIR/s/MKL_INCLUDE_DIR/MKL_INCLUDE/g"  cmake/Dependencies.cmake
sed -i -e "/MKL/s/find_package(MKL REQUIRED)/find_package(MKL CONFIG REQUIRED)/g"  cmake/Dependencies.cmake
