if ((Get-Command "cmake.exe" -ErrorAction SilentlyContinue) -eq $null)
{
  start-process -wait -verb runAs chocolatey.exe -argumentlist "install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'"
}
