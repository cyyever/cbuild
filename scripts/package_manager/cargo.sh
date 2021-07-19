for pkg in ${cargo_pkgs}; do
  cargo install --git ${pkg}
done
