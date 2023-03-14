# if command -v pacman
# then
#   rm -rf $INSTALL_PREFIX/cudnn
#   mkdir -p $INSTALL_PREFIX/cudnn/include
#   cp -f -r /usr/include/cudnn* $INSTALL_PREFIX/cudnn/include
#   mkdir -p $INSTALL_PREFIX/cudnn/lib
#   cp -f -r /usr/lib/libcudnn* $INSTALL_PREFIX/cudnn/lib
# else
mkdir -p $SRC_DIR
cd $SRC_DIR
wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.4.1/local_installers/11.6/cudnn-linux-x86_64-8.4.1.50_cuda11.6-archive.tar.xz
tar -xf cudnn*xz
rm -rf cudnn*xz
cd cudnn*
rm -rf $INSTALL_PREFIX/cudnn
mkdir -p $INSTALL_PREFIX/cudnn
find lib -name '*static.a' | xargs -I file rm file
cp -f -r include $INSTALL_PREFIX/cudnn
cp -f -r lib $INSTALL_PREFIX/cudnn
rm -rf *
# fi
