for pkg in ${yay_pkgs}; do
  if ! yay -Q ${pkg} && ! yay -Qg ${pkg} >/dev/null; then
    yay -S --noconfirm ${pkg}
  fi
done
