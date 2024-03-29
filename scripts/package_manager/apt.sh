if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  export DEBIAN_FRONTEND=noninteractive
fi
if ! test -t 0; then
  export DEBIAN_FRONTEND=noninteractive
fi
has_pkg_installed=0
for pkg in ${apt_pkgs}; do
  if ! dpkg-query --show --showformat='${db:Status-Status}' $pkg | grep -i -E '^installed' >/dev/null; then
    if [[ "${no_apt_update:=1}" == 0 ]]; then
      ${sudo_cmd} apt-get update
      no_apt_update=1
    fi
    ${sudo_cmd} apt-get install --no-install-recommends -y $pkg
    has_pkg_installed=1
  fi
done

if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  if [[ "${has_pkg_installed}" == 1 ]]; then
    ${sudo_cmd} rm -rf /var/lib/apt/lists/*
    ${sudo_cmd} rm -rf /usr/local/share/doc
    ${sudo_cmd} rm -rf /usr/local/share/man
    ${sudo_cmd} apt-get clean -y
    ${sudo_cmd} apt-get purge -y
  fi
fi
