cd $SRC_DIR
build_type="variant=release"
if [[ "${BUILD_TYPE}" == "Debug" ]]; then
  build_type="variant=debug"
fi

./bootstrap.sh --prefix=$INSTALL_PREFIX --with-python=python3
./b2 stage -j${MAX_JOBS} link=shared threading=multi ${build_type}
./b2 install threading=multi link=shared variant=release ${build_type}
