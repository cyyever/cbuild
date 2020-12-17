cd $env:SRC_DIR
Get-Content CMakeLists.txt | Where-Object { $_ -notmatch 'enable_testing\(\)' } | Where-Object { $_ -notmatch 'add_subdirectory\(tests\)' } | Set-Content CMakeLists.txt2
mv -Force CMakeLists.txt2 CMakeLists.txt
