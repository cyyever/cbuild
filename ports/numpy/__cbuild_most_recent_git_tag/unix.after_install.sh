if [[ "${test_numpy}" == "1" ]]; then
  cd ~
  ${CBUILD_PYTHON_EXE} -c "import numpy;numpy.test()"
fi

for file in ~/.local/lib/python3.10/site-packages/tensorboard/util/tensor_util.py ~/.local/lib/python3.10/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py; do
  if test -f ${file}; then
    ${sed_cmd} -e 's/\<np.bool\>/bool/g' -i ${file}
    ${sed_cmd} -e 's/\<np.object\>/object/g' -i ${file}
  fi
done
