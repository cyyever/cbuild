for pkg in ${stack_pkgs}; do
  stack install -j 1 --local-bin-path="${INSTALL_PREFIX}/bin" ${pkg}
done
