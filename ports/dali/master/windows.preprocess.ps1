cd $env:SRC_DIR
if ((Test-Path ${env:INSTALL_PREFIX}/include/dali)) {
rm -r -Force ${env:INSTALL_PREFIX}/include/dali
rm -r -Force ${env:INSTALL_PREFIX}/lib/libdali*
}
