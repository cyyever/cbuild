cd $env:SRC_DIR
./bootstrap.sh --prefix=$env:INSTALL_PREFIX --with-python=python3
./b2 stage -j$env:MAX_JOBS link=shared threading=multi
./b2 install threading=multi link=shared
