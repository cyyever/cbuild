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
