if command -v systemctl; then
  sudo systemctl enable bluetooth
fi
if command -v balooctl; then
  sudo balooctl disable
fi
if test -f ~/.config/baloofilerc; then
  if ! grep 'Indexing-Enabled' ~/.config/baloofilerc; then
    ${sed_cmd} -e '1 i\Indexing-Enabled=false' -i ~/.config/baloofilerc
    ${sed_cmd} -e '1 i\[Basic Settings]' -i ~/.config/baloofilerc
  fi
fi
if command -v psd; then
  systemctl --user enable psd
fi
