export python=${CBUILD_PYTHON_EXE}
cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/include/dali
rm -rf ${INSTALL_PREFIX}/lib/libdali*
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
${sed_cmd} -i -e 's/COMMAND python/COMMAND python3/g' $(grep 'COMMAND python'  -r * -l)
