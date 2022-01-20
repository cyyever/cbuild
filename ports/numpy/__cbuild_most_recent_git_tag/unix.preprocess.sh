cd ${SRC_DIR}

: >$HOME/.numpy-site.cfg
printf "[openblas]\n" | tee -a $HOME/.numpy-site.cfg
printf "libraries = openblas\n" | tee -a $HOME/.numpy-site.cfg
printf "library_dirs=%s/lib\n" "${INSTALL_PREFIX}" | tee -a $HOME/.numpy-site.cfg
printf "include_dirs=%s/include\n" "${INSTALL_PREFIX}" | tee -a $HOME/.numpy-site.cfg

if ${CBUILD_PYTHON_EXE} -c "import sys; print(sys.flags.nogil)"
then
${sed_cmd} -e  "/define PyArray_REFCOUNT/s/PyArray_REFCOUNT(obj).*/PyArray_REFCOUNT(obj) Py_REFCNT(obj)/" -i 	 numpy/core/include/numpy/ndarrayobject.h
fi

if [[ "${run_test}" == "1" ]]; then
  run_test=0
  export test_numpy=1
else
  export test_numpy=0
fi
