cd ${SRC_DIR}
${sed_cmd} -i -e '/EAI_NODATA/s/EAI_NODATA/EAI_NONAME/g' lib/cpp/src/thrift/transport/TSocket.cpp
