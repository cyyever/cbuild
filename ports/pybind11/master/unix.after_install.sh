cd $SRC_DIR
${CBUILD_PYTHON_EXE} setup.py build_ext --inplace
${CBUILD_PYTHON_EXE} setup.py install --user --force
