cd $env:SRC_DIR
ant download-deps
ant
mkdir -force $env:INSTALL_PREFIX/textidote
cp -r textidote.jar $env:INSTALL_PREFIX/textidote
