cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/include/dali
rm -rf ${INSTALL_PREFIX}/lib/libdali*
${sed_cmd} -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CXX_STANDARD/s/14/20/' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CUDA_STANDARD/s/14/17/' CMakeLists.txt
${sed_cmd} -i -e '/dali_test.*dynlink_nvml/d' dali/CMakeLists.txt
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
# ${sed_cmd} -i -e '/PYTHON_VERSIONS/s/3.6;3.7;3.8;/3.10;/g' CMakeLists.txt
${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden//g' CMakeLists.txt
for cmake_file in $(grep 'COMMAND python ' -r * -l | grep -i cmake); do
  ${sed_cmd} -i -e 's/COMMAND python /COMMAND python3 /' ${cmake_file}
done

${sed_cmd} -i -e '/testing::dali_extra_path/d' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e '/db.fuzzing/d' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e 's#jpeg_folder = make_string.*#jpeg_folder = "/tmp/";#' dali/fuzzing/dali_harness.h

${sed_cmd} -i -e '/sys.version_inf.*== 10/d' dali/python/nvidia/dali/backend.py
${sed_cmd} -i -e '/DALI support for Python 3.10 is experime/d' dali/python/nvidia/dali/backend.py
${sed_cmd} -i -e '/may not work/d' dali/python/nvidia/dali/backend.py
# ${sed_cmd} -i -e 's/<3.10/<=3.10/g' dali/python/setup.py.in

# ${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden/-fsanitize=thread/g' CMakeLists.txt
