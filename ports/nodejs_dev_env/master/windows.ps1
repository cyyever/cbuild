if ((Test-Path "~/AppData/Local/nvim/")) {
rm -r -force ~/AppData/Local/nvim/
}
if ((Test-Path "~/AppData/Local/nvim-data/")) {
rm -r -force ~/AppData/Local/nvim-data/
}
if (!(Test-Path "~/AppData/Local/nvim/")) {
    mkdir -p "~/AppData/Local/nvim/"
    mkdir -p "~/AppData/Local/nvim/lua/config"
}

cp -r $env:SRC_DIR ~/AppData/Local/nvim/
cp ~/AppData/Local/nvim/vimfiles/init.lua ~/AppData/Local/nvim/
cp ~/AppData/Local/nvim/vimfiles/coc-settings.json ~/AppData/Local/nvim/
cp ~/AppData/Local/nvim/vimfiles/lua/config/* ~/AppData/Local/nvim/lua/config
