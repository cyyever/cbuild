if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  ${CBUILD_PYTHON_EXE} -c "import os"
  echo "export PATH=${PATH}" >>~/.profile
  echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >>~/.profile
  echo "export LIBRARY_PATH=${LIBRARY_PATH}" >>~/.profile
  echo "export PYTHONPATH=${PYTHONPATH}" >>~/.profile
fi
