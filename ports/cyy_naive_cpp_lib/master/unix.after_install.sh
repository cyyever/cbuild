if [[ "${FEATURE_torch_python_binding}" == "1" ]] || [[ "${FEATURE_video_python_binding}" == "1" ]]; then
  cd ${__SRC_DIR}
  if test -d build; then
    ${sudo_cmd} rm -rf build
  fi
  ${__CBUILD_PYTHON_EXE} -m pip uninstall $(${__CBUILD_PYTHON_EXE} setup.py --name) -y || true
  env cmake_build_dir=${BUILD_DIR} ${__CBUILD_PYTHON_EXE} setup.py install --user --force
  if [[ "${run_test}" == "1" ]]; then
    if [[ "${FEATURE_torch_python_binding}" == "1" ]]; then
      cd ${SRC_DIR}/python_binding/test/torch
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
    if [[ "${FEATURE_video_python_binding}" == "1" ]]; then
      cd ${SRC_DIR}/python_binding/test/video
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
fi
