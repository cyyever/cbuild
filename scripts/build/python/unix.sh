cd ${__SRC_DIR}
if test -f "setup.py"; then
  if test -d build; then
    ${sudo_cmd} rm -rf build
  fi
  ${__CBUILD_PYTHON_EXE} -m pip uninstall $(${__CBUILD_PYTHON_EXE} setup.py --name) -y || true
  if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    ${__CBUILD_PYTHON_EXE} setup.py install --force
  else
    ${__CBUILD_PYTHON_EXE} setup.py install --user --force
  fi
  if [[ "${run_test}" == "1" ]]; then
    if [[ "${PACKAGE_VERSION}" == "master" ]]; then
      ${CBUILD_PYTHON_EXE} -m pytest || true
    else
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
fi
