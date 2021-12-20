msys2_shell.cmd -msys -defterm -no-start -full-path -c 'pacman -Syu --noconfirm'
foreach ($pkg in $env:msys_pkgs.Split(" ")) {
    msys2_shell.cmd -msys -defterm -no-start -full-path -c "pacman -S --needed --noconfirm $pkg"
}
