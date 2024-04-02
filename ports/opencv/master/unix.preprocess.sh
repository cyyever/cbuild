cd ${SRC_DIR}

${sed_cmd} -i -e 's/CMAKE_CXX_STANDARD 11/CMAKE_CXX_STANDARD 14/' cmake/OpenCVDetectCXXCompiler.cmake
