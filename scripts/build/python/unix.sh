cd ${__SRC_DIR}
if test -f requirements.txt; then
  if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    ${__CBUILD_PIP_EXE} install -r requirements.txt --force
  else
    ${__CBUILD_PIP_EXE} install -r requirements.txt --user --force
  fi
fi
if test -f "setup.py"; then
  if test -d build; then
    ${sudo_cmd} rm -rf build
  fi
  # pkg_name=$(${__CBUILD_PYTHON_EXE} setup.py --name)
  # for _ in $(seq 5); do
  #   ${__CBUILD_PIP_EXE} uninstall $pkg_name -y || true
  # done
  if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    ${__CBUILD_PYTHON_EXE} setup.py install --force
  else
    ${__CBUILD_PYTHON_EXE} setup.py install --user --force
  fi
  if [[ "${run_test}" == "1" ]]; then
    if [[ "${PACKAGE_VERSION}" == "master" ]]; then
      ${__CBUILD_PYTHON_EXE} -m pytest || true
    else
      ${__CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
fi
