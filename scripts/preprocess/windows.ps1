$env:Path = $env:Path + [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:INSTALL_PREFIX = $env:INSTALL_PREFIX.Replace("\", "/")

cd (vswhere -latest -prerelease -property installationPath)
cd VC/Auxiliary/Build

C:\Windows\System32\cmd.exe /c "call vcvarsall.bat x64 && set" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path "Env:$($matches[1])" -Value $matches[2]
    }
}

Set-Alias -Name sed_cmd -Value sed
$CBUILD_PIP_EXE="$env:CBUILD_PYTHON_EXE -m pip"

cd $Env:temp
if (! (Test-Path env:py_pkg_name)) {
    $env:py_pkg_name = $env:PACKAGE_NAME
}

1..5 | foreach {
    Invoke-Expression "$CBUILD_PIP_EXE uninstall -y $env:py_pkg_name"
}
