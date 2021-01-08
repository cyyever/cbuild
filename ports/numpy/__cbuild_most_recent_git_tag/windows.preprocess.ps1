cd $env:SRC_DIR

Set-Content -Path site.cfg -Value "[openblas]"
Add-Content -Path site.cfg -Value "libraries = openblas"
Add-Content -Path site.cfg -Value "library_dirs=${env:INSTALL_PREFIX}/lib"
Add-Content -Path site.cfg -Value "include_dirs=${env:INSTALL_PREFIX}/include"
