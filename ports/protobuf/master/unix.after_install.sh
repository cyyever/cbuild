cd ${SRC_DIR}/python
${__CBUILD_PIP_EXE} uninstall protobuf -y || true
${__CBUILD_PYTHON_EXE} setup.py build_ext --inplace
${__CBUILD_PYTHON_EXE} setup.py install --user --force
