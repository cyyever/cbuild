for pkg in ${yum_pkgs}; do
  if ! rpm -q ${pkg} >/dev/null; then
    ${sudo_cmd} yum install -y ${pkg}
  fi
done
