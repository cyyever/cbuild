for pkg in ${bsd_ports_pkgs}; do
  cd /usr/ports/${pkg}
  ${sudo_cmd} env BATCH=1 make deinstall
  ${sudo_cmd} env BATCH=1 FORCE_PKG_REGISTER=1 make install clean
done
