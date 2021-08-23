cd ${SRC_DIR}
${sed_cmd} -i -e '/CMAKE_CUDA_FLAGS.*OpenMP/d' cpp/CMakeLists.txt
${sed_cmd} -i -e 's/-DGUNROCK_BUILD_TESTS=OFF/& -DCUDA_TOOLKIT_ROOT_DIR=${CUDA_TOOLKIT_ROOT_DIR} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}/' cpp/cmake/thirdparty/get_gunrock.cmake
