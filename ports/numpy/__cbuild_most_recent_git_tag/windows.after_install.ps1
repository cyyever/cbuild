cd( Get-ChildItem (python -m site --user-site) | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -match "numpy"})
pwd
cd numpy
cd core
cp ${env:INSTALL_PREFIX}/bin/openblas.dll .
cp C:/OneAPI/compiler/latest/windows/redist/intel64_win/compiler/*dll .
if ($env:test_numpy -eq "1") {
    cd $home
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -c 'import numpy; numpy.test();'"
}
