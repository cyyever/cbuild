cd ${SRC_DIR}
if [[ "${run_test}" == "1" ]]; then
  ${CBUILD_PYTHON_EXE} test/run_test.py --continue-through-error
fi
