for pkg in ${mingw64_pkgs}; do
  if ! pacman -Q $pkg &>/dev/null && ! pacman -Qg $pkg &>/dev/null; then
    if [[ "${no_pacman_update:=1}" == 1 ]]; then
      pacman -Syu --noconfirm
      no_pacman_update=0
    fi
    pacman -S --needed --noconfirm $pkg
  fi
done
