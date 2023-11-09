cd ${SRC_DIR}
ant download-deps
ant
mkdir -p $INSTALL_PREFIX/textidote
cp -r textidote-0.9.jar $INSTALL_PREFIX/textidote/textidote.jar
