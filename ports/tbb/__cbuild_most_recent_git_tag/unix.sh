#no need to build tbb
rm -rf ${INSTALL_PREFIX}/tbb
rsync -rv --exclude=.git ${SRC_DIR} ${INSTALL_PREFIX}
