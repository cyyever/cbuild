cd ${SRC_DIR}

: >site.cfg
printf "[openblas]\n" | tee -a site.cfg
printf "libraries = openblas\n" | tee -a site.cfg
printf "library_dirs=%s/lib\n" "${INSTALL_PREFIX}" | tee -a site.cfg
printf "include_dirs=%s/include\n" "${INSTALL_PREFIX}" | tee -a site.cfg
