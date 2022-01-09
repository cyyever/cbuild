cd ${__SRC_DIR}
if test -f requirements.txt; then
  ${CBUILD_PIP_EXE} install -r requirements.txt --user
fi

if test -f "setup.py"; then
  if [[ -z ${reuse_build+x} ]]; then
    if test -d build; then
      ${sudo_cmd} rm -rf build
    fi
  fi

  if [[ -z ${PYTHON_BUILD_CMD+x} ]]; then
    build_cmd="${CBUILD_PYTHON_EXE} setup.py build_ext --inplace"
  else
    build_cmd="$PYTHON_BUILD_CMD"
  fi
  if [[ -n ${need_compilation_json+x} ]] && command -v bear; then
    build_cmd="bear -- ${build_cmd}"
  fi
  ${build_cmd}
  if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    ${CBUILD_PYTHON_EXE} setup.py install --force
  else
    ${CBUILD_PYTHON_EXE} setup.py install --user --force
  fi
  if [[ "${run_test}" == "1" ]]; then
    if [[ "${PACKAGE_VERSION}" == "master" ]]; then
      ${CBUILD_PYTHON_EXE} -m pytest || true
    else
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
  if test -d build; then
    BUILD_DIR="$(pwd)/build"
  fi
fi
