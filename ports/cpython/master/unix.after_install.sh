if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  ${CBUILD_PYTHON_EXE} -c "import os"
  echo "export PATH=${PATH}" >>~/.bashrc
  echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >>~/.bashrc
  echo "export LIBRARY_PATH=${LIBRARY_PATH}" >>~/.bashrc
  echo "export PYTHONPATH=${PYTHONPATH}" >>~/.bashrc
fi

cd ${INSTALL_PREFIX}/python/bin
cp ./python3 ./python
