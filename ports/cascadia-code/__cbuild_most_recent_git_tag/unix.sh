cd $SRC_DIR
rm -rf ~/.local/share/fonts
mkdir -p ~/.local/share/fonts
cp -r * ~/.local/share/fonts
fc-cache
