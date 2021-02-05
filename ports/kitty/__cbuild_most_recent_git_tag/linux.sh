${sudo_cmd} env "PATH=$PATH" "LD_LIBRARY_PATH=$LD_LIBRARY_PATH" ${CBUILD_PYTHON_EXE} setup.py linux-package --prefix /usr/local
exit 0
