for pkg in ${brew_cask_pkgs}; do
	  if ! brew cask list ${pkg}  >/dev/null ; then
    brew cask install ${pkg}
  fi
done
