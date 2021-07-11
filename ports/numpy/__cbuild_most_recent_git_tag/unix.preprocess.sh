cd ${SRC_DIR}

: >$HOME/.numpy-site.cfg
printf "[openblas]\n" | tee -a $HOME/.numpy-site.cfg
printf "libraries = openblas\n" | tee -a $HOME/.numpy-site.cfg
printf "library_dirs=%s/lib\n" "${INSTALL_PREFIX}" | tee -a $HOME/.numpy-site.cfg
printf "include_dirs=%s/include\n" "${INSTALL_PREFIX}" | tee -a $HOME/.numpy-site.cfg

if [[ "${run_test}" == "1" ]]; then
  run_test=0
  export test_numpy=1
fi
