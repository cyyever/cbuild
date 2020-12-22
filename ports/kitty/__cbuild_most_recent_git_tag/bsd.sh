rm -rf ${INSTALL_PREFIX}/kitty
rsync -rv --exclude=.git ${SRC_DIR} ${INSTALL_PREFIX} 1>/dev/null

cd ${INSTALL_PREFIX}/kitty
${make_cmd}
