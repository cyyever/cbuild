cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/include/dali
rm -rf ${INSTALL_PREFIX}/lib/libdali*
${sed_cmd} -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CXX_STANDARD/s/14/20/' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CUDA_STANDARD/s/14/17/' CMakeLists.txt
${sed_cmd} -i -e '/dali_test.*dynlink_nvml/d' dali/CMakeLists.txt
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
${sed_cmd} -i -e '/PYTHON_VERSIONS/s/3.6;3.7;3.8;//g' CMakeLists.txt
${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden//g' CMakeLists.txt
${sed_cmd} -i -e 's/Deallocate(AllocType type/Deallocate(int type/g' dali/kernels/alloc.h
${sed_cmd} -i -e 's/Deallocate(alloc_type/Deallocate((int)alloc_type/g' dali/kernels/alloc.h
${sed_cmd} -i -e 's/Deallocate(AllocType type/Deallocate(int type/g' dali/kernels/alloc.cc
${sed_cmd} -i -e 's/VALUE_SWITCH(type/VALUE_SWITCH((AllocType)type/g' dali/kernels/alloc.cc
${sed_cmd} -i -e '/testing::dali_extra_path/d' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e '/db.fuzzing/d' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e 's#jpeg_folder = make_string.*#jpeg_folder = "/tmp/";#' dali/fuzzing/dali_harness.h
${sed_cmd} -i -e 's/assert(disp_info_);/assert(disp_info);/g' dali/operators/reader/nvdecoder/nvdecoder.cc
# ${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden/-fsanitize=undefined -fsanitize=address/g' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden/-fsanitize=thread/g' CMakeLists.txt
