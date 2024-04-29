if [[ -n ${py_pkg_name+x} ]]; then
  cd /tmp
  for _ in $(seq 2); do
    ${CBUILD_PIP_EXE} uninstall $py_pkg_name -y || true
  done
fi
cd ${__SRC_DIR}
if test -f requirements.txt; then
  ${sed_cmd} -i -e '/git.*ssh/d' requirements.txt
  ${CBUILD_PIP_EXE} install -r requirements.txt --user
fi

if test -f "pyproject.toml" && [[ -z ${use_setup_py+x} ]]; then
  if [[ -n "${py_pkg_name+x}" ]]; then
    if ~/.local/bin/toml get --toml-path pyproject.toml project.name >/dev/null 2>/dev/null; then
      py_pkg_name=$(~/.local/bin/toml get --toml-path pyproject.toml project.name)
    fi
  fi
  if [[ -z "${py_pkg_name+x}" ]]; then
    for _ in $(seq 2); do
      ${CBUILD_PIP_EXE} uninstall $py_pkg_name -y || true
    done
  fi
  if [[ "${reuse_build:=0}" == "0" ]]; then
    for d in build *egg-info; do
      if test -d ${d}; then
        if ! rm -rf ${d}; then
          ${sudo_cmd} rm -rf ${d}
        fi
      fi
    done
  fi

  build_cmd="${CBUILD_PYTHON_EXE} -m pip install --no-build-isolation . --user --force"
  if [[ -n ${need_compilation_json+x} ]] && command -v bear; then
    build_cmd="bear -- ${build_cmd}"
  fi
  clang_tidy_fix_succ=0
  if run_clang_tidy_fix; then
    clang_tidy_fix_succ=1
  fi
  ${build_cmd}
  if [[ "$clang_tidy_fix_succ" == "0" ]]; then
    if run_clang_tidy_fix; then
      ${build_cmd}
    fi
  fi
  if [[ "${run_test}" == "1" ]]; then
    if [[ -n ${TEST_SUBDIR+x} ]]; then
      cd ${TEST_SUBDIR}
    fi
    if [[ "${PACKAGE_VERSION}" == "master" ]]; then
      ${CBUILD_PYTHON_EXE} -m pytest || true
    else
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
  if test -d build; then
    BUILD_DIR="$(pwd)/build"
  fi
elif test -f "setup.py"; then
  if [[ "${reuse_build:=0}" == "0" ]]; then
    for d in build dist; do
      if test -d ${d}; then
        if ! rm -rf ${d}; then
          ${sudo_cmd} rm -rf ${d}
        fi
      fi
    done
  fi

  if [[ -z ${PYTHON_BUILD_CMD+x} ]]; then
    build_cmd="${CBUILD_PYTHON_EXE} setup.py build_ext --inplace"
  else
    build_cmd="$PYTHON_BUILD_CMD"
  fi
  if [[ -n ${need_compilation_json+x} ]] && command -v bear; then
    build_cmd="bear -- ${build_cmd}"
  fi
  clang_tidy_fix_succ=0
  if run_clang_tidy_fix; then
    clang_tidy_fix_succ=1
  fi
  ${build_cmd}
  if [[ "$clang_tidy_fix_succ" == "0" ]]; then
    if run_clang_tidy_fix; then
      ${build_cmd}
    fi
  fi
  if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    ${CBUILD_PYTHON_EXE} setup.py install --force
  else
    if ! ${CBUILD_PYTHON_EXE} setup.py install --user --force; then
      ${CBUILD_PIP_EXE} install . --user --verbose
    fi
  fi
  if [[ "${run_test}" == "1" ]]; then
    if [[ -n ${TEST_SUBDIR+x} ]]; then
      cd ${TEST_SUBDIR}
    fi
    if [[ "${PACKAGE_VERSION}" == "master" ]]; then
      ${CBUILD_PYTHON_EXE} -m pytest || true
    elif [[ "${PACKAGE_VERSION}" == "main" ]]; then
      ${CBUILD_PYTHON_EXE} -m pytest || true
    else
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
  if test -d build; then
    BUILD_DIR="$(pwd)/build"
  fi
fi
