#no need to build tbb
if ((Test-Path -Path ${env:INSTALL_PREFIX}/tbb)) {
    rm -r -force ${env:INSTALL_PREFIX}/tbb
}
cp -r ${env:SRC_DIR} ${env:INSTALL_PREFIX}/tbb
