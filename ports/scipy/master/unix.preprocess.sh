cd ${SRC_DIR}

: >$HOME/.numpy-site.cfg
printf "[openblas]\n" | tee -a $HOME/.numpy-site.cfg
printf "libraries = openblas\n" | tee -a $HOME/.numpy-site.cfg
printf "library_dirs=%s/lib\n" "${INSTALL_PREFIX}" | tee -a $HOME/.numpy-site.cfg
printf "include_dirs=%s/include\n" "${INSTALL_PREFIX}" | tee -a $HOME/.numpy-site.cfg

${sed_cmd} -i -e '/define BOOST_MATH_NO_LONG_DOUBLE_MATH_FUNCTIONS/d' ${SRC_DIR}/scipy/_lib/boost/boost/math/tools/config.hpp
if [[ "${run_test}" == "1" ]]; then
  run_test=0
  export test_numpy=1
else
  export test_numpy=0
fi
