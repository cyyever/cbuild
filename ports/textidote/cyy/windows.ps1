cd $env:SRC_DIR
ant download-deps
ant
mkdir -Force $env:INSTALL_PREFIX/textidote
cp -r textidote-0.9.jar $env:INSTALL_PREFIX/textidote
