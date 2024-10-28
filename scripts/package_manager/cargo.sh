for pkg in ${cargo_pkgs}; do
  if ! cargo install ${pkg}; then
    if ! cargo install --git ${pkg} --branch main; then
      if ! cargo install --git ${pkg} --branch master; then
        cargo install --git ${pkg}
      fi
    fi
  fi
done
if [[ "$(uname)" != "FreeBSD" ]]; then
  cargo install cargo-update
  if ! cargo install-update -a; then
    cargo install -f cargo-update
    cargo install-update -a
  fi
fi
