foreach ($pkg in $env:cargo_pkgs.Split(" ")) {
    cargo install --git $pkg
}
