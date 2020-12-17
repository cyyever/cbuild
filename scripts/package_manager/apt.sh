for pkg in ${apt_pkgs}; do
  if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
    export DEBIAN_FRONTEND=noninteractive
  fi
  if ! test -t 0; then
    export DEBIAN_FRONTEND=noninteractive
  fi
  if ! dpkg-query --show --showformat='${db:Status-Status}' $pkg | grep -i -E '^installed' >/dev/null; then
    if [[ "${no_apt_update:=1}" == 1 ]]; then
      ${sudo_cmd} apt-get update
      no_apt_update=0
    fi
    ${sudo_cmd} apt-get install --no-install-recommends -y $pkg
  fi
done
