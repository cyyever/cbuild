if [[ "${FEATURE_torch_python_binding:=0}" == "1" ]] || [[ "${FEATURE_video_python_binding:=0}" == "1" ]]; then
  cd ${__SRC_DIR}
  ${CBUILD_PYTHON_EXE} -m pip uninstall $(${CBUILD_PYTHON_EXE} setup.py --name) -y || true
  env cmake_build_dir=${BUILD_DIR} ${CBUILD_PYTHON_EXE} setup.py install --user --force
  if [[ "${run_test}" == "1" ]]; then
    if [[ "${FEATURE_torch_python_binding:=0}" == "1" ]]; then
      cd ${SRC_DIR}/python_binding/test/torch
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
    if [[ "${FEATURE_video_python_binding:=0}" == "1" ]]; then
      cd ${SRC_DIR}/python_binding/test/video
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
    if [[ "${FEATURE_cv_python_binding:=0}" == "1" ]]; then
      cd ${SRC_DIR}/python_binding/test/cv
      ${CBUILD_PYTHON_EXE} -m pytest
    fi
  fi
fi
