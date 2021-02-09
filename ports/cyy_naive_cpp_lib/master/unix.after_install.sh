if [[ "${FEATURE_python_binding}" == "1" ]]; then
  if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    __CBUILD_PYTHON_EXE="${sudo_cmd} env LD_LIBRARY_PATH=${INSTALL_PREFIX}/python/lib ${CBUILD_PYTHON_EXE}"
  else
    __CBUILD_PYTHON_EXE="${CBUILD_PYTHON_EXE}"
  fi
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
