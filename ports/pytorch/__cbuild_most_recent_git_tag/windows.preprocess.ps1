cd "$env:SRC_DIR"
sed -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'CUDA_USE_STATIC_CUDA_RUNTIME', 'CAFFE2_USE_MKL','USE_NCCL',/" tools/setup_helpers/cmake.py
sed -i -e '/^ *check_submodules()/d' setup.py
sed -i -e '/Dependencies.cmake/d' CMakeLists.txt
sed -i -e '/utf-8"/ainclude(cmake/Dependencies.cmake)' CMakeLists.txt
