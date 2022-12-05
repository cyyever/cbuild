cd $SRC_DIR
if test -d ~/Library/Fonts
then
	cp -r * ~/Library/Fonts
else
  rm -rf ~/.local/share/fonts
  mkdir -p ~/.local/share/fonts
  cp -r * ~/.local/share/fonts
  fc-cache
fi
