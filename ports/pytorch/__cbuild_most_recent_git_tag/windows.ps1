$path = vswhere -latest -prerelease -property installationPath
cd $path
cd VC/Auxiliary/Build
cmd /c "call `"vcvars64.bat`" && set > %temp%\\vcvars.txt"
Get-Content "$env:temp/vcvars.txt" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Content "env:\$($matches[1])" $matches[2]
    }
}

python -m pip uninstall -y torch
cd $env:SRC_DIR
Remove-Item build -Recurse -ErrorAction Ignore
$env:MAX_JOBS = 5
$env:CMAKE_MODULE_PATH = $env:INSTALL_PREFIX
$env:CMAKE_BUILD_TYPE = $env:BUILD_TYPE
if ($env:BUILD_TYPE -like "debug") {
    $env:CMAKE_EXE_LINKER_FLAGS_DEBUG = "/DEBUG:FASTLINK"
    $env:CMAKE_SHARED_LINKER_FLAGS_DEBUG = "/DEBUG:FASTLINK"
    $env:CMAKE_STATIC_LINKER_FLAGS_DEBUG = "/DEBUG:FASTLINK"
    $env:CMAKE_MODULE_LINKER_FLAGS_DEBUG = "/DEBUG:FASTLINK"
}
python setup.py install --user
