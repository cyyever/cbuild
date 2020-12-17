$new_path = ""
[System.Collections.ArrayList]$path_list = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User).split(";")
$path_list.add("${env:ProgramFiles}\NVIDIA Corporation\NVSMI")
$path_list.add("${env:ProgramFiles}\NVIDIA Corporation\NvToolsExt\bin\x64")
foreach ( $my_path  in ($path_list | select -Unique    )  ) {
    if ([string]::IsNullOrEmpty($my_path)) {
        continue
    }
    if (!(Test-Path -Path $my_path  -PathType Container)) {
        continue
    }
    $new_path += ";$my_path"
}

[Environment]::SetEnvironmentVariable( "Path", $new_path, [EnvironmentVariableTarget]::User)

if ((Get-Command "chocolatey.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Start-Process -wait -verb runAs -filepath powershell.exe -argumentlist "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine"); [System.Environment]::GetEnvironmentVariable("Path", "User")
}

Start-Process -wait -verb runAs chocolatey.exe -argumentlist "feature enable --name='useEnhancedExitCodes'"
# Start-Process -wait -verb runAs chocolatey.exe -argumentlist "upgrade all -y"
