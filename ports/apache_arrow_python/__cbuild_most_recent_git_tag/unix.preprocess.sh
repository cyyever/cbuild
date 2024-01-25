cd ${SRC_DIR}
if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/AMD64/amd64/g' cpp/cmake_modules/SetupCxxFlags.cmake
fi
${sed_cmd} -i -e '/Cython.__version__/s/.*/if False:/g' python/setup.py
