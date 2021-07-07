cd ${SRC_DIR}
${sed_cmd} -i -e 's/-Werror//g' benchmarks/CMakeLists.txt
${sed_cmd} -i -e 's/-Werror//g' tests/CMakeLists.txt
