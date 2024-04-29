cd ${SRC_DIR}
${sed_cmd} -i -e '/set(TBB_WARNING_LEVEL -Wall -Wextra/s/set(TBB_WARNING_LEVEL -Wall -Wextra.*/set(TBB_WARNING_LEVEL -Wall -Wextra)/g' cmake/compilers/GNU.cmake
