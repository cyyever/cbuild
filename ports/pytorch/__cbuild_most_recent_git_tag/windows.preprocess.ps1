cd "$env:SRC_DIR"
sed_cmd -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
