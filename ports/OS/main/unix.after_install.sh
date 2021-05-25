if command -v git; then
  git config --global pull.rebase false
  git config --global core.autocrlf input
fi
