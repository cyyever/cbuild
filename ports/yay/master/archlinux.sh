if command -v yay
then
  exit 0
fi
cd $__SRC_DIR
makepkg -si
