cd $SRC_DIR
if test -d ~/Library/Fonts
then
	cp -r * ~/Library/Fonts
else
	cp -r * ~/.local/share/fonts/ttf
	fc-cache
fi
