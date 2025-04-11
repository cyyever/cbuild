foreach ($pkg in $env:cargo_pkgs.Split(" ")) {
    cargo install --git $pkg
}
cargo install -f cargo-update
cargo install-update -a
