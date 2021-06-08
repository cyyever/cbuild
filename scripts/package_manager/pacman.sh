for pkg in ${pacman_pkgs}; do
  if ! pacman -Q $pkg &>/dev/null && ! pacman -Qg $pkg &>/dev/null; then
    if [[ "${no_pacman_update:=1}" == 1 ]]; then
      ${sudo_cmd} pacman -Syu --noconfirm
      no_pacman_update=0
    fi
    ${sudo_cmd} pacman -S --needed --noconfirm $pkg
  fi
done
