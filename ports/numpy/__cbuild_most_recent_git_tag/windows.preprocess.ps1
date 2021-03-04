cd $env:SRC_DIR

Set-Content -Path ${home}/site.cfg -Value "[openblas]"
Add-Content -Path ${home}/site.cfg -Value "libraries = openblas"
Add-Content -Path ${home}/site.cfg -Value "library_dirs=${env:INSTALL_PREFIX}/lib"
Add-Content -Path ${home}/site.cfg -Value "include_dirs=${env:INSTALL_PREFIX}/include"
