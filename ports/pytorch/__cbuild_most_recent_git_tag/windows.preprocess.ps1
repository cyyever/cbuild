cd "$__SRC_DIR"
sed_cmd -i -e "/INTEL_MKL_DIR/s/,/,'USE_MKLDNN', 'CUDA_USE_STATIC_CUDA_RUNTIME', 'CAFFE2_USE_MKL','USE_NCCL',/" tools/setup_helpers/cmake.py
sed_cmd -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
