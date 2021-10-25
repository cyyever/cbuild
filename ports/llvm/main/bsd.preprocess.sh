cd ${SRC_DIR}
${sed_cmd} -i -e 's/define SANITIZER_STAT_LINUX.*/define SANITIZER_STAT_LINUX 0/g' compiler-rt/lib/msan/msan_interceptors.cpp
