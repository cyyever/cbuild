cd ${SRC_DIR}
${sed_cmd} -i -e '/CMAKE_CUDA_FLAGS.*OpenMP/d' cpp/CMakeLists.txt
