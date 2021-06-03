if command -v yay
then
  exit 0
fi
cd $SRC_DIR
makepkg -si
