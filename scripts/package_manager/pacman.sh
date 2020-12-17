${sudo_cmd} pacman -Syu --noconfirm
for pkg in ${pacman_pkgs}; do
  if ! pacman -Q $pkg &>/dev/null && ! pacman -Qg $pkg &>/dev/null; then
    ${sudo_cmd} pacman -S --needed --noconfirm $pkg
  fi
done
