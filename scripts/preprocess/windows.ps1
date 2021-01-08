$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine"); [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:INSTALL_PREFIX = $env:INSTALL_PREFIX.Replace("\", "/")
