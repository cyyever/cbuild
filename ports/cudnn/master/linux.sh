cd $SRC_DIR
if test -d $INSTALL_PREFIX/cuda; then
  rm -rf $INSTALL_PREFIX/cuda
fi
cp -f -r cuda $INSTALL_PREFIX/
