cd $SRC_DIR
mkdir -p $INSTALL_PREFIX/include
cp -f -r cuda/include/* $INSTALL_PREFIX/include
mkdir -p $INSTALL_PREFIX/lib64
cp -f -r cuda/lib64/* $INSTALL_PREFIX/lib64
rm -rf cuda
