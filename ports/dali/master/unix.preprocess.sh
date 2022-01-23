cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/include/dali
rm -rf ${INSTALL_PREFIX}/lib/libdali*
${sed_cmd} -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt
${sed_cmd} -i -e '/dali_test.*dynlink_nvml/d' dali/CMakeLists.txt
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden//g' CMakeLists.txt

${sed_cmd} -i -e '/testing::dali_extra_path/d' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e '/db.fuzzing/d' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e 's#jpeg_folder = make_string.*#jpeg_folder = "/tmp/";#' dali/fuzzing/dali_harness.h
