msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman -Syu --disable-download-timeout --noconfirm'
msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman --disable-download-timeout --noconfirm -S gcc'
msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman --disable-download-timeout --noconfirm -S make'
