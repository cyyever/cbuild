if ((Get-Command "chocolatey.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Start-Process -Wait -Verb runAs -FilePath powershell.exe -ArgumentList "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine"); [System.Environment]::GetEnvironmentVariable("Path", "User")
}
Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "install -y python3 --installargs 'Include_debug=1;Include_symbols=1'"
Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "install -y git --params '/GitAndUnixToolsOnPath'"
# Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "install -y pwsh"
Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "install -y gsudo"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine"); [System.Environment]::GetEnvironmentVariable("Path", "User")
python -m pip install --upgrade pip
python -m pip install --upgrade --user setuptools
python -m pip install --upgrade --user FileLock-git
python -m pip install --upgrade --user requests
python -m pip install --upgrade --user colorlog
python -m pip install --upgrade --user psutil
python -m pip install --upgrade --user tqdm
python -m pip install --upgrade --user git+https://github.com/cyyever/naive_python_lib.git@main --force
