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
sed -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'USE_NCCL',/" tools/setup_helpers/cmake.py

sed -i -e '/^ *check_submodules()/d' setup.py
rm cmake/Modules/FindMKL.cmake
sed -i -e '1 i\include(CheckFunctionExists)'  cmake/Modules/FindLAPACK.cmake
