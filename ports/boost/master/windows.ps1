cd $env:SRC_DIR
./bootstrap.sh --prefix=$env:INSTALL_PREFIX --with-python=python3
./b2 link=shared threading=multi address-model=64 stage
./b2 install threading=multi link=shared
