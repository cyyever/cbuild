if command -v -q brew
then
  mkdir -p ~/.local/lib/python${PYTHONVERSION}/site-packages/numpy/.dylibs
  cp ${INSTALL_PREFIX}/lib/libopenblas* ~/.local/lib/python${PYTHONVERSION}/site-packages/numpy/.dylibs
fi
if [[ "${test_numpy}" == "1" ]]; then
  cd ~
  ${CBUILD_PYTHON_EXE} -c "import numpy;numpy.test()"
fi

for file in ~/.local/lib/python${PYTHONVERSION}/site-packages/tensorboard/util/tensor_util.py ~/.local/lib/python${PYTHONVERSION}/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py; do
  if test -f ${file}; then
    ${sed_cmd} -e 's/\<np.bool\>/bool/g' -i ${file}
    ${sed_cmd} -e 's/\<np.object\>/object/g' -i ${file}
  fi
done
