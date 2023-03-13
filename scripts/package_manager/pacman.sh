for pkg in ${pacman_pkgs}; do
  if ! pacman -Q $pkg &>/dev/null && ! pacman -Qg $pkg &>/dev/null; then
    if [[ "${no_pacman_update:=1}" == 1 ]]; then
      ${sudo_cmd} pacman -Sy --noconfirm
      no_pacman_update=0
    fi
    ${sudo_cmd} pacman -S --needed --noconfirm $pkg
  fi
done
if [[ "${BUILD_CONTEXT_docker:=0}" == "1" ]]; then
  echo "clear cache"
  ${sudo_cmd} rm -rf /var/cache/pacman/pkg/
  ${sudo_cmd} pacman -Scc --noconfirm
fi
