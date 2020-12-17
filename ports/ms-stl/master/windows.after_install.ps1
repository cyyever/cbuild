cd $env:BUILD_DIR
if ((Test-Path -Path ${env:INSTALL_PREFIX}/STL  -PathType Container)) {
  rm -r -force ${env:INSTALL_PREFIX}/STL
}
cp -r out ${env:INSTALL_PREFIX}/STL
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";${env:INSTALL_PREFIX}/STL/bin/amd64"  ,
    [EnvironmentVariableTarget]::User)
