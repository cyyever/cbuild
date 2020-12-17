if ((Get-Command "chocolatey.exe" -ErrorAction SilentlyContinue) -eq $null) {
  start-process -wait -verb runAs -filepath powershell.exe -argumentlist "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine");[System.Environment]::GetEnvironmentVariable("Path","User")
}
start-process -wait -verb runAs chocolatey.exe -argumentlist "install -y python3 --installargs 'Include_debug=1;Include_symbols=1'"
start-process -wait -verb runAs chocolatey.exe -argumentlist "install -y git --params '/GitAndUnixToolsOnPath'"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine");[System.Environment]::GetEnvironmentVariable("Path","User")
python -m pip install --upgrade pip
python -m pip install --user setuptools
python -m pip install --user FileLock-git
python -m pip install --user requests
python -m pip install --user requests
python -m pip install --upgrade --user git+https://github.com/tqdm/tqdm.git@master#egg=tqdm
