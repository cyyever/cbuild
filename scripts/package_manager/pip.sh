if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  if ! command -v ${CBUILD_PYTHON_EXE} &>/dev/null; then
    __CBUILD_PYTHON_EXE=python3
  else
    __CBUILD_PYTHON_EXE="${sudo_cmd} env LD_LIBRARY_PATH=${INSTALL_PREFIX}/python/lib ${CBUILD_PYTHON_EXE}"
  fi
else
  __CBUILD_PYTHON_EXE="${CBUILD_PYTHON_EXE}"
fi
${__CBUILD_PYTHON_EXE} -m ensurepip --default-pip
#PIP_CMD="${__CBUILD_PYTHON_EXE} -m pip --use-deprecated legacy-resolver"
PIP_CMD="${__CBUILD_PYTHON_EXE} -m pip"

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  ${PIP_CMD} install --upgrade pip
  for pkg in ${pip_pkgs}; do
    ${PIP_CMD} install --upgrade ${pkg}
  done
else
  ${PIP_CMD} install --upgrade --user pip
  for pkg in ${pip_pkgs}; do
     ${PIP_CMD} install --upgrade --user ${pkg}
  done
fi
