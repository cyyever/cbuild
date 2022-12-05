if [[ "${BUILD_CONTEXT_macos:=0}" == "0" ]]; then
cd ${SRC_DIR}/python
rm -rf protobuf.egg-info
rm -rf build
${CBUILD_PYTHON_EXE} setup.py build_ext --inplace
${CBUILD_PYTHON_EXE} setup.py install --user --force

# sudo mkdir -p /usr/local/lib
# sudo   cp ${INSTALL_PREFIX}/lib/libproto* /usr/local/lib
fi
