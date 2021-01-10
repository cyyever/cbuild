$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($env:static_analysis -eq "1") {
    $env:CMAKE_GENERATOR = "native"
}
$env:INSTALL_PREFIX = $env:INSTALL_PREFIX.Replace("\", "/")
