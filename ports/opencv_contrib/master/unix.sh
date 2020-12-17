mkdir -p ${INSTALL_PREFIX}/opencv_contrib
rm -rf ${INSTALL_PREFIX}/opencv_contrib/*
cp -r ${SRC_DIR}/* ${INSTALL_PREFIX}/opencv_contrib
