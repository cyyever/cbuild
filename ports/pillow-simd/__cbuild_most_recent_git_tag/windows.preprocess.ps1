# cd $env:INSTALL_PREFIX/bin
# $py_dir=(Split-Path -Path  ((get-command python).source))
# cp zlib*dll ${py_dir}
# cp jpeg*dll ${py_dir}
1..2 | foreach {
    Invoke-Expression "$CBUILD_PIP_EXE uninstall -y pillow"
}
1..2 | foreach {
    Invoke-Expression "$CBUILD_PIP_EXE uninstall -y pillow-simd"
}
