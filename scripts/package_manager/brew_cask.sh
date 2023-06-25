for pkg in ${brew_cask_pkgs}; do
  if ! brew list --cask ${pkg} >/dev/null; then
    brew install --cask ${pkg}
  fi
done
