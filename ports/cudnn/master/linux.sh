cd $SRC_DIR
rm -rf $INSTALL_PREFIX/cuda
mkdir -p $INSTALL_PREFIX/cuda
cp -f -r cuda/include $INSTALL_PREFIX/cuda
mkdir -p $INSTALL_PREFIX/lib64
cp -f -r cuda/lib64 $INSTALL_PREFIX/cuda
rm -rf cuda
