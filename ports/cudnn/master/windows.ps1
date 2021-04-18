cd $env:SRC_DIR
Remove-Item $env:INSTALL_PREFIX/cuda -Recurse -ErrorAction Ignore
cp -r cuda $env:INSTALL_PREFIX
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";${env:INSTALL_PREFIX}/cuda/bin"  ,
    [EnvironmentVariableTarget]::User)
