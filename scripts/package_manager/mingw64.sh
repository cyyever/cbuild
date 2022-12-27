pacman -Syu --noconfirm
for pkg in ${mingw64_pkgs}; do
  if ! pacman -Q $pkg &>/dev/null && ! pacman -Qg $pkg &>/dev/null; then
    pacman -S --needed --noconfirm $pkg
  fi
done
