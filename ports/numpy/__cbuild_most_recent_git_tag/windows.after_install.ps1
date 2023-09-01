cd $env:INSTALL_PREFIX/bin
$py_dir = (Split-Path -Path  ((Get-Command python).source))
gsudo cp *dll ${py_dir}
if ($env:test_numpy -eq "1") {
    cd $home
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -c 'import numpy; numpy.test();'"
}
