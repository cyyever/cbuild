cd $env:SRC_DIR
sed_cmd -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','USE_MEMORY_SANITIZERS','USE_MSAN','USE_TSAN','NO_VPTR','USE_MKLDNN',/" tools/setup_helpers/cmake.py
sed_cmd -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
