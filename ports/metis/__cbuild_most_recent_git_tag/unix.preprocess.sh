cd ${SRC_DIR}
${sed_cmd} -i -e "/add_library/s/$/\\n target_link_libraries(metis PUBLIC GKlib)/" libmetis/CMakeLists.txt
