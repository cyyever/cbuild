cd $env:SRC_DIR

Set-Content -Path ${home}/.numpy-site.cfg -Value "[openblas]"
Add-Content -Path ${home}/.numpy-site.cfg -Value "libraries = openblas"
Add-Content -Path ${home}/.numpy-site.cfg -Value "library_dirs=${env:INSTALL_PREFIX}/lib"
Add-Content -Path ${home}/.numpy-site.cfg -Value "include_dirs=${env:INSTALL_PREFIX}/include"
