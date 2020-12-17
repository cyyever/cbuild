cd ${SRC_DIR}
ant download-deps
ant
mkdir -p $INSTALL_PREFIX/textidote
cp -r textidote.jar $INSTALL_PREFIX/textidote
