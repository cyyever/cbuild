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
sed -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'USE_NCCL','CMAKE_CXX_STANDARD','CMAKE_CUDA_STANDARD'/" tools/setup_helpers/cmake.py
sed -i -e '/^ *check_submodules()/d' setup.py
rm cmake/Modules/FindMKL.cmake
sed -i -e '/pentelemet/d' torch/CMakeLists.txt
sed -i -e '/my_env = _overlay_windows_vcvars/d' tools/build_pytorch_libs.py
sed -i -e '/cmake/d' requirements.txt
sed -i -e '/lintrunner/d' requirements.txt
