PIP_CMD="${CBUILD_PYTHON_EXE} -m pip"

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  ${CBUILD_PYTHON_EXE} -m ensurepip --default-pip || true
  ${PIP_CMD} install --upgrade pip
  for pkg in ${pip_nodeps_pkgs}; do
    ${PIP_CMD} install --upgrade --no-deps ${pkg}
  done
else
  ${PIP_CMD} install --upgrade pip
  for pkg in ${pip_nodeps_pkgs}; do
    ${PIP_CMD} install --upgrade --user --no-deps ${pkg}
  done
fi
