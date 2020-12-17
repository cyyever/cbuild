foreach ($pkg in $env:npm_pkgs.Split(" ")) {
  npm install --prefix "$env:INSTALL_PREFIX" $pkg
}
