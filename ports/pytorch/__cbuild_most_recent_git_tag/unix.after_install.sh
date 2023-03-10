cd ${SRC_DIR}
if [[ "${run_test}" == "1" ]]; then
  ${CBUILD_PYTHON_EXE} test/run_test.py --continue-through-error
fi
if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  ${CBUILD_PYTHON_EXE} -c "import torch"
fi
