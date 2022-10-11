cd $SRC_DIR
if [[ $BUILD_CONTEXT_macos == "1" ]]
then
	cp -r * ~/Library/Fonts
else
	cp -r * ~/.local/share/fonts/ttf
	fc-cache
fi
