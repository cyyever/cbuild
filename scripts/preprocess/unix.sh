sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

sed_cmd=sed
if command -v gsed >/dev/null; then
  sed_cmd=gsed
fi

make_cmd="make"
if command -v gmake >/dev/null; then
  make_cmd="gmake"
fi

# if test -d "${INSTALL_PREFIX}/python"; then
#   export PYTHONHOME="${INSTALL_PREFIX}/python"
# fi

if [[ -z ${INSTALL_SUBDIR+x} ]]; then
  __INSTALL_PREFIX=${INSTALL_PREFIX}
else
  __INSTALL_PREFIX=${INSTALL_PREFIX}/${INSTALL_SUBDIR}
fi

if [[ -n ${SRC_DIR+x} ]]; then
  if [[ -z ${SRC_SUBDIR+x} ]]; then
    __SRC_DIR=${SRC_DIR}
  else
    __SRC_DIR=${SRC_DIR}/${SRC_SUBDIR}
  fi
fi

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  __CBUILD_PYTHON_EXE="${sudo_cmd} env LD_LIBRARY_PATH=${INSTALL_PREFIX}/python/lib ${CBUILD_PYTHON_EXE}"
else
  __CBUILD_PYTHON_EXE="${CBUILD_PYTHON_EXE}"
fi
