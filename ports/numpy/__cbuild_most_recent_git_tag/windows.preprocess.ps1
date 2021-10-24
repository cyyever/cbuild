cd $env:SRC_DIR

Set-Content -Path ${home}/.numpy-site.cfg -Value "[openblas]"
Add-Content -Path ${home}/.numpy-site.cfg -Value "libraries = openblas"
Add-Content -Path ${home}/.numpy-site.cfg -Value "library_dirs=${env:INSTALL_PREFIX}/lib"
Add-Content -Path ${home}/.numpy-site.cfg -Value "include_dirs=${env:INSTALL_PREFIX}/include"

if ($env:run_test -eq "1") {
  $env:run_test="0"
  $env:test_numpy="1"
} else {
  $env:test_numpy="0"
}
