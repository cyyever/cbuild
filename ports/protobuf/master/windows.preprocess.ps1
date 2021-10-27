cd $env:INSTALL_PREFIX
if ((Test-Path -Path "include/google/protobuf" -PathType Container)) {
  Remove-Item include/google/protobuf -Recurse -Force
}
