for pkg in ${brew_pkgs}; do
	  if ! brew list ${pkg}  >/dev/null ; then
    brew install ${pkg}
  fi
done
