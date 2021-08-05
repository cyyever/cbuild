cd ${SRC_DIR}
${sed_cmd} -i -e "/std::tr1/d" src/glog/stl_logging.h.in
