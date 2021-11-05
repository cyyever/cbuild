if [[ "${FEATURE_python_binding:=0}" == "1" ]]; then
  cd ${__SRC_DIR}
  ${CBUILD_PYTHON_EXE} -m pip uninstall $(${CBUILD_PYTHON_EXE} setup.py --name) -y || true
  env cmake_build_dir=${BUILD_DIR} ${CBUILD_PYTHON_EXE} setup.py install --user --force
  if [[ "${run_test}" == "1" ]]; then
    if [[ "${FEATURE_python_binding:=0}" == "1" ]]; then
      cd ${SRC_DIR}/python_binding/test
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
fi
