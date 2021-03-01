$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:INSTALL_PREFIX = $env:INSTALL_PREFIX.Replace("\", "/")

$path = vswhere -latest -prerelease -property installationPath
cd $path
cd VC/Auxiliary/Build

cmd /c "call vcvarsall.bat x64 && set > %temp%\\vcvars.txt"
Get-Content "$env:temp/vcvars.txt" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path "Env:$($matches[1])" -Value $matches[2]
    }
}
