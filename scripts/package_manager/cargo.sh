for pkg in ${cargo_pkgs}; do
  if ! cargo install ${pkg}; then
    if ! cargo install --git ${pkg}; then
      cargo install --git ${pkg} --branch main
    fi
  fi
done
if [[ "$(uname)" != "FreeBSD" ]]; then
  cargo install cargo-update
  cargo install-update -a
fi
