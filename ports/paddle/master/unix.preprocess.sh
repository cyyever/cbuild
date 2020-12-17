cd ${SRC_DIR}

sed_cmd="sed"
if command -v gsed >/dev/null; then
  sed_cmd="gsed"
fi
${sed_cmd} -i -e 's/cmake_minimum_required(VERSION 3.10)/cmake_minimum_required(VERSION 3.18)/' CMakeLists.txt
${sed_cmd} -i -e '/cmake_minimum_required/a cmake_policy(SET CMP0097 NEW)' CMakeLists.txt
${sed_cmd} -i -e 's/\-Werror//' cmake/flags.cmake
