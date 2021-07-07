cd ${SRC_DIR}

sed -i -e "s#include_dirs = \[\]#include_dirs = \[\"$INSTALL_PREFIX/cuda/include\"\]#" install/build.py
sed -i -e "s#library_dirs = \[\]#library_dirs = \[\"$INSTALL_PREFIX/cuda/lib64\"\]#" install/build.py
