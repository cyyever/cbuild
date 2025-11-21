PIP_CMD="${CBUILD_PYTHON_EXE} -m pip -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  ${CBUILD_PYTHON_EXE} -m ensurepip --default-pip || true
  ${PIP_CMD} install --upgrade pip
  for pkg in ${pip_pkgs}; do
    ${PIP_CMD} install --upgrade ${pkg}
  done
else
  ${PIP_CMD} install --upgrade pip
  for pkg in ${pip_pkgs}; do
    ${PIP_CMD} install --upgrade --user ${pkg}
  done
fi
