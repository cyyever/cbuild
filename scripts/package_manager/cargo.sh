for pkg in ${cargo_pkgs}; do
  if ! cargo install --git ${pkg}; then
    cargo install --git ${pkg} --branch main
  fi
done
