my_name=$(whoami)
shell_path="$INSTALL_PREFIX/fish-shell/bin/fish"
if test -f "$shell_path"; then
  if ! grep -q "$shell_path" /etc/shells; then
    echo "$shell_path" | ${sudo_cmd} tee -a /etc/shells
    ${sudo_cmd} chsh -s "$shell_path" ${my_name}
  fi
fi
