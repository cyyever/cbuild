if [[ "${BUILD_CONTEXT_macos:=0}" == "1" ]]; then
  # mkdir -p ~/.local/lib/python${PYTHONVERSION}/site-packages/numpy/.dylibs
  # cp ${INSTALL_PREFIX}/lib/libopenblas* ~/.local/lib/python${PYTHONVERSION}/site-packages/numpy/.dylibs
  sudo mkdir -p /usr/local/lib
  sudo cp ${INSTALL_PREFIX}/lib/libopenblas* /usr/local/lib
fi
if [[ "${test_numpy}" == "1" ]]; then
  cd ~
  ${CBUILD_PYTHON_EXE} -c "import numpy;numpy.test()"
fi
