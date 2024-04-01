cd "$env:SRC_DIR"
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/lib/libc10*
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/lib/libtorch*
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/lib/libshm*
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/lib/libcaffe2*
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/include/torch
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/include/ATen
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/include/c10
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/include/caffe2
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/include/sleef.h
rm -r -ErrorAction SilentlyContinue $env:INSTALL_PREFIX/include/xnnpack.h
sed -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'CUDA_USE_STATIC_CUDA_RUNTIME', 'CAFFE2_USE_MKL','USE_NCCL','MKL_OPENMP_TYPE','MKL_OPENMP_LIBRARY',/" tools/setup_helpers/cmake.py

sed -i -e '/^ *check_submodules()/d' setup.py
rm cmake/Modules/FindMKL.cmake
sed -i -e "/MKL_INCLUDE_DIR/s/MKL_INCLUDE_DIR/MKL_INCLUDE/g"  cmake/public/mkl.cmake
sed -i -e "/target_link_libraries/s/..MKL_LIBRARIES./MKL::MKL/g"  cmake/public/mkl.cmake
sed -i -e "/MKL_INCLUDE_DIR/s/MKL_INCLUDE_DIR/MKL_INCLUDE/g"  cmake/Dependencies.cmake
sed -i -e '1 i\include(CheckFunctionExists)'  cmake/Modules/FindLAPACK.cmake
sed -i -e '2 i\#endif'  torch/csrc/dynamo/cpython_defs.h
sed -i -e '2 i\extern "C" {'  torch/csrc/dynamo/cpython_defs.h
sed -i -e '2 i\#ifdef __cplusplus'  torch/csrc/dynamo/cpython_defs.h
sed -i -e '$a\#ifdef __cplusplus'  torch/csrc/dynamo/cpython_defs.h
sed -i -e '$a\}'  torch/csrc/dynamo/cpython_defs.h
sed -i -e '$a\#endif'  torch/csrc/dynamo/cpython_defs.h
$env:MKL_OPENMP_LIBRARY = $env:MKL_OPENMP_LIBRARY -replace "/", "\\"
$env:MKL_OPENMP_LIBRARY = $env:MKL_OPENMP_LIBRARY -replace "C:\\P", "C:\\\\P"
