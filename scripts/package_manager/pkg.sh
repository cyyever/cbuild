for pkg in ${pkg_pkgs}; do
  if ! pkg query '%n' ${pkg} >/dev/null; then
    ${sudo_cmd} pkg install -y ${pkg}
  fi
done
