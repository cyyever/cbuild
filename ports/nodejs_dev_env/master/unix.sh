mkdir -p ~/.config/nvim
rm -rf ~/.config/nvim/init.vim || true
rm -rf ~/.config/nvim/lua || true
mkdir -p ~/.config/nvim/lua/config
cp ${SRC_DIR}/init.lua ~/.config/nvim
cp ${SRC_DIR}/lua/config/* ~/.config/nvim/lua/config
