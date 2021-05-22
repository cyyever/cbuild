cd ${SRC_DIR}
${sed_cmd} -i -e '/fstack-protector-strong/d' configure.ac
${sed_cmd} -i -e '/-Wmissing-prototypes -Wstrict-prototypes/d' configure.ac
${sed_cmd} -i -e '/-Wl,--as-needed/d' configure.ac
