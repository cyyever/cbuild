cd $env:INSTALL_PREFIX/bin
$py_dir = (Split-Path -Path  ((Get-Command python).source))
gsudo cp *.dll ${py_dir}
