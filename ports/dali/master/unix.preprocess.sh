cd ${SRC_DIR}
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
${sed_cmd} -i -e '/CMAKE_CXX_STANDARD/s/14/17/g' CMakeLists.txt
