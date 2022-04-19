cd ${SRC_DIR}

${sed_cmd} -e "s#include_dirs = ..#include_dirs = ['$INSTALL_PREFIX/cudnn/include','$INSTALL_PREFIX/cuda/include']#" -i install/cupy_builder/install_build.py
${sed_cmd} -e "s#library_dirs = ..#library_dirs = ['$INSTALL_PREFIX/cudnn/lib','$INSTALL_PREFIX/cuda/lib','$INSTALL_PREFIX/cuda/lib64']#" -i install/cupy_builder/install_build.py
