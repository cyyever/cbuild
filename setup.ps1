if ((Get-Command "choco.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Start-Process -Wait -Verb runAs -FilePath powershell.exe -ArgumentList "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://choco.org/install.ps1'))"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine"); [System.Environment]::GetEnvironmentVariable("Path", "User")
}
Start-Process -Wait -Verb runAs choco.exe -ArgumentList "install -y python --installargs 'Include_debug=1;Include_symbols=1'"
Start-Process -Wait -Verb runAs choco.exe -ArgumentList "install -y git --params '/GitAndUnixToolsOnPath'"
# Start-Process -Wait -Verb runAs choco.exe -ArgumentList "install -y pwsh"
Start-Process -Wait -Verb runAs choco.exe -ArgumentList "install -y gsudo"
Start-Process -Wait -Verb runAs choco.exe -ArgumentList "install -y vswhere"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine"); [System.Environment]::GetEnvironmentVariable("Path", "User")
python -m pip install --upgrade pip --user
python -m pip install --upgrade --user -r requirements.txt
python -m pip install --upgrade --user git+https://github.com/cyyever/naive_python_lib.git@main --force
