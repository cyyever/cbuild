if [[ "${run_test}" == "1" ]]; then
  cd ~
  ${CBUILD_PYTHON_EXE} -c "import numpy;numpy.test()"
  run_test=0
fi
