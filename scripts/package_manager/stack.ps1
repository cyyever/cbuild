foreach ($pkg in $env:stack_pkgs.Split(" ")) {
  stack install -j 1 --local-bin-path="$env:INSTALL_PREFIX/bin" $pkg
}
