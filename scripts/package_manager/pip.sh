PIP_CMD="${CBUILD_PYTHON_EXE} -m pip"
PIP_INSTALL_CMD="${CBUILD_PYTHON_EXE} -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  ${CBUILD_PYTHON_EXE} -m ensurepip --default-pip || true
  ${PIP_INSTALL_CMD} --upgrade pip
  for pkg in ${pip_pkgs}; do
    ${PIP_INSTALL_CMD} --upgrade ${pkg}
  done
else
  ${PIP_INSTALL_CMD} --upgrade pip
  for pkg in ${pip_pkgs}; do
    ${PIP_INSTALL_CMD} --upgrade --user ${pkg}
  done
fi
