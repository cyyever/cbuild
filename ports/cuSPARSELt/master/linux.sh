cd $SRC_DIR
mkdir -p $INSTALL_PREFIX/include
cp -f -r libcusparse_lt*/include/* $INSTALL_PREFIX/include
mkdir -p $INSTALL_PREFIX/lib
cp -f -r libcusparse_lt*/lib/* $INSTALL_PREFIX/lib
rm -rf libcusparse_lt*
