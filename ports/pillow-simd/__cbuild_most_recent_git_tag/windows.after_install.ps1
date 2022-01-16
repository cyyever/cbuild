cd $env:INSTALL_PREFIX/bin
$py_dir=(Split-Path -Path  ((get-command python).source))
cp zlib*dll "${py_dir}\DLLs"
cp jpeg*dll "${py_dir}\DLLs"
