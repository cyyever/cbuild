cd $SRC_DIR
./bootstrap.sh --prefix=$INSTALL_PREFIX --with-python=python3
./b2 stage -j${MAX_JOBS} link=shared threading=multi
./b2 install threading=multi link=shared
