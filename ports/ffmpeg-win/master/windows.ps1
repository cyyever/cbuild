cd $env:SRC_DIR
cd ffmpeg-*
ls *
mv bin/* $env:INSTALL_PREFIX/bin
mv lib/* $env:INSTALL_PREFIX/lib
mv include/* $env:INSTALL_PREFIX/include
