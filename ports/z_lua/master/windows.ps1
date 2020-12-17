mkdir -Force "$env:INSTALL_PREFIX/z.lua"
rm -r -Force "$env:INSTALL_PREFIX/z.lua"
cp -r ${env:SRC_DIR}/* "$env:INSTALL_PREFIX/z.lua"
