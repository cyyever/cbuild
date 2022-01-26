cd ${SRC_DIR}

${sed_cmd} -i -e 's/target_include_directories(libprotobuf SYSTEM PUBLIC/target_include_directories(libprotobuf PUBLIC/' 3rdparty/protobuf/CMakeLists.txt
${sed_cmd} -i -e 's/IF (OpenBLAS_FOUND)/IF (OpenBLAS_FOUND) \nset(OpenBLAS_LIB "${OpenBLAS_LIB};gfortran")\n/g' cmake/OpenCVFindOpenBLAS.cmake
${sed_cmd} -i -e 's/CMAKE_CXX_STANDARD 11/CMAKE_CXX_STANDARD 14/' cmake/OpenCVDetectCXXCompiler.cmake
