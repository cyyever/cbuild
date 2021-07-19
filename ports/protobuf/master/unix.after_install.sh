cd ${SRC_DIR}/python
rm -rf protobuf.egg-info
rm -rf build
${CBUILD_PYTHON_EXE} setup.py build_ext --inplace
${CBUILD_PYTHON_EXE} setup.py install --user --force
