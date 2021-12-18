cd $SRC_DIR
rm -rf $INSTALL_PREFIX/cudnn
mkdir -p $INSTALL_PREFIX/cudnn
cp -f -r include $INSTALL_PREFIX/cudnn
mkdir -p $INSTALL_PREFIX/lib64
cp -f -r lib64 $INSTALL_PREFIX/cudnn
rm -rf *
