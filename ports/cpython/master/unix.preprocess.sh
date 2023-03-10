if [[ -n ${SRC_DIR+x} ]]; then
  cd ${SRC_DIR}
  ${sed_cmd} -i -e "s#system_lib_dirs = \['#system_lib_dirs = \['${INSTALL_PREFIX}\/lib','${INSTALL_PREFIX}\/lib64','#" setup.py
  ${sed_cmd} -i -e "s#system_include_dirs = \['#system_include_dirs = \['${INSTALL_PREFIX}\/include','#" setup.py
fi
