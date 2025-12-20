mkdir -p ~/.config/nvim
cd ~/.config/nvim
if test -d vimfiles; then
  rm -rf vimfiles
fi
rm -rf ~/.config/nvim/init.vim | true
rm -rf ~/.config/nvim/lua | true
mkdir -p ~/.config/nvim/vimfiles
cp -r ${SRC_DIR}/* ~/.config/nvim/vimfiles/
mkdir -p ~/.config/nvim/lua/config
cp ~/.config/nvim/vimfiles/init.lua ~/.config/nvim
cp ~/.config/nvim/vimfiles/coc-settings.json ~/.config/nvim
cp ~/.config/nvim/vimfiles/lua/config/* ~/.config/nvim/lua/config
