cd $SRC_DIR
ls libcutensor
mkdir -p $INSTALL_PREFIX/cuda/include
cp -f -r libcutensor/include/* $INSTALL_PREFIX/cuda/include
mkdir -p $INSTALL_PREFIX/cuda/lib
cp -f -r libcutensor/lib/11/* $INSTALL_PREFIX/cuda/lib
rm -rf libcutensor
