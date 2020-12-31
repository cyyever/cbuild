cd ${SRC_DIR}

printf "[openblas]" | tee -a site.cfg
printf "libraries = openblas" | tee -a site.cfg
printf "library_dirs=%s/lib" "${INSTALL_PREFIX}" | tee -a site.cfg
printf "include_dirs=%s/include" "${INSTALL_PREFIX}" | tee -a site.cfg
