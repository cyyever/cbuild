cd $SRC_DIR

cp -f -r libcusparse_lt*/include/* $INSTALL_PREFIX/include
mkdir -p $INSTALL_PREFIX/cuda/lib64
cp -f -r libcusparse_lt*/lib/* $INSTALL_PREFIX/lib
rm -rf libcusparse_lt*
