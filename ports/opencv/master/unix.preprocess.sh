cd ${SRC_DIR}

sed_cmd="sed"
if command -v gsed >/dev/null; then
  sed_cmd="gsed"
fi

${sed_cmd} -i -e 's/target_include_directories(libprotobuf SYSTEM PUBLIC/target_include_directories(libprotobuf PUBLIC/' 3rdparty/protobuf/CMakeLists.txt
sed -i -e 's/IF (OpenBLAS_FOUND)/IF (OpenBLAS_FOUND) \nset(OpenBLAS_LIB "${OpenBLAS_LIB};gfortran")\n/g' cmake/OpenCVFindOpenBLAS.cmake
