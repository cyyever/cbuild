my_name=$(whoami)
if which fish
then
shell_path="$(which fish)"
else
shell_path="$INSTALL_PREFIX/fish-shell/bin/fish"
fi

if test -f "$shell_path"; then
  if ! grep -q "$shell_path" /etc/shells; then
    echo "$shell_path" | ${sudo_cmd} tee -a /etc/shells
  fi
	${sudo_cmd} chsh -s "$shell_path" ${my_name}
fi
