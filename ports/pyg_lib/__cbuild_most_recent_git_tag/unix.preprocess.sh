cd ${SRC_DIR}
${sed_cmd} -i -e "/add_library/s/add_library(metis /add_library(metis SHARED/g" third_party/METIS/libmetis/CMakeLists.txt
