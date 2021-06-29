cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/include/dali
rm -rf ${INSTALL_PREFIX}/lib/libdali*
${sed_cmd} -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt
${sed_cmd} -i -e '/dali_test.*dynlink_nvml/d' dali/CMakeLists.txt
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
# ${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden//g' CMakeLists.txt
${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden/-fsanitize=undefined -fsanitize=address/g' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden/-fsanitize=thread/g' CMakeLists.txt
