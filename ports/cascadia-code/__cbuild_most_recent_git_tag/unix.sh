cd $SRC_DIR
mkdir -p ~/.local/share/fonts
cp -r * ~/.local/share/fonts
fc-cache
