cd $SRC_DIR/libnvjpeg_2k
pwd
if test -d $INSTALL_PREFIX/cuda; then
  rm -rf $INSTALL_PREFIX/cuda
fi
mkdir -p $INSTALL_PREFIX/include
cp include/* $INSTALL_PREFIX/include
mkdir -p $INSTALL_PREFIX/lib64
cp lib64/*.a $INSTALL_PREFIX/lib64
cp lib64/*.so $INSTALL_PREFIX/lib64
