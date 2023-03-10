if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  ${CBUILD_PYTHON_EXE} -c "import os"
fi
