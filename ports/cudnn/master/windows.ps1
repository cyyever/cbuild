cd $env:SRC_DIR
cd cudnn*
Remove-Item $env:INSTALL_PREFIX/cudnn -Recurse -ErrorAction Ignore
mkdir $env:INSTALL_PREFIX/cudnn
cp -r * $env:INSTALL_PREFIX/cudnn/
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";${env:INSTALL_PREFIX}/cudnn/bin"  ,
    [EnvironmentVariableTarget]::User)
