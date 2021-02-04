cd ${SRC_DIR}
${sed_cmd} -i -e "s#PREFIX = /usr/local#PREFIX = ${INSTALL_PREFIX}#" Makefile
