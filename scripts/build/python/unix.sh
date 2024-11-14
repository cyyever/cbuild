if [[ -n ${py_pkg_name+x} ]]; then
  cd /tmp
  for _ in $(seq 2); do
    ${CBUILD_PIP_EXE} uninstall $py_pkg_name -y || true
  done
fi
cd ${__SRC_DIR}
if test -f requirements.txt; then
  ${sed_cmd} -i -e '/torch/d' requirements.txt
  ${sed_cmd} -i -e '/nvidia/d' requirements.txt
  ${sed_cmd} -i -e '/setuptools/d' requirements.txt
  ${sed_cmd} -i -e '/numpy/d' requirements.txt
  ${sed_cmd} -i -e '/cython/d' requirements.txt
  ${CBUILD_PIP_EXE} install --upgrade -r requirements.txt --user
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
  ${sed_cmd} -i -e '/"scipy",/d' pyproject.toml
  ${sed_cmd} -i -e '/"scikit-learn",/d' pyproject.toml
  ${sed_cmd} -i -e '/"nvidia",/d' pyproject.toml
  ${sed_cmd} -i -e '/"numpy",/d' pyproject.toml
  if [[ "${reuse_build:=0}" == "0" ]]; then
    for d in build *egg-info; do
      if test -d ${d}; then
        if ! rm -rf ${d}; then
          ${sudo_cmd} rm -rf ${d}
        fi
      fi
    done
  fi

  build_cmd="${CBUILD_PIP_EXE} install --no-build-isolation . --user --force --verbose"
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
    ${CBUILD_PYTHON_EXE} -m pytest || true
  fi
  if test -d build; then
    BUILD_DIR="$(pwd)/build"
  fi
elif test -f "setup.py"; then
  ${sed_cmd} -i -e '/scipy/d' setup.py
  ${sed_cmd} -i -e '/scikit-learn/d' setup.py
  ${sed_cmd} -i -e '/nvidia/d' setup.py
  ${sed_cmd} -i -e '/numpy/d' setup.py
  ${sed_cmd} -i -e '/cython/d' setup.py
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
  ${CBUILD_PYTHON_EXE} setup.py install
  if [[ "${run_test}" == "1" ]]; then
    if [[ -n ${TEST_SUBDIR+x} ]]; then
      cd ${TEST_SUBDIR}
    fi
    ${CBUILD_PYTHON_EXE} -m pytest || true
  fi
  if test -d build; then
    BUILD_DIR="$(pwd)/build"
  fi
fi
