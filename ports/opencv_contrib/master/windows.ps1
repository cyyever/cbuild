cd $env:INSTALL_PREFIX
if ((Test-Path -Path ${env:INSTALL_PREFIX}/opencv_contrib)) {
    rm -r -force ${env:INSTALL_PREFIX}/opencv_contrib
}

cp -r ${env:SRC_DIR} $env:INSTALL_PREFIX
