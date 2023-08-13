# then
#   mkdir -p $INSTALL_PREFIX/cudnn/lib
#   cp -f -r /usr/lib/libcudnn* $INSTALL_PREFIX/cudnn/lib
# else
if ! command -v pacman; then
  cd $SRC_DIR
  cd cudnn*
  rm -rf $INSTALL_PREFIX/cudnn
  mkdir -p $INSTALL_PREFIX/cudnn
  cp -f -r include $INSTALL_PREFIX/cudnn
  cp -f -r lib $INSTALL_PREFIX/cudnn
  rm -rf *
fi
