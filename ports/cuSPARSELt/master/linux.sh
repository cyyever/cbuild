cd $SRC_DIR

mkdir -p $INSTALL_PREFIX/cuda/include
cp -f -r libcusparse_lt/include/* $INSTALL_PREFIX/cuda/include
mkdir -p $INSTALL_PREFIX/cuda/lib64
cp -f -r libcusparse_lt/lib64/* $INSTALL_PREFIX/cuda/lib64
rm -rf libcusparse_lt
