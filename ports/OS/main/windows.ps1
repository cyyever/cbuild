$new_path = ""
[System.Collections.ArrayList]$path_list = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User).split(";")
$path_list.add("${env:ProgramFiles}/Cmake/bin")
foreach ( $my_path  in ($path_list | Select-Object -Unique    )  ) {
    if ([string]::IsNullOrEmpty($my_path)) {
        continue
    }
    if (!(Test-Path -Path $my_path  -PathType Container)) {
        continue
    }
    $new_path += ";$my_path"
}
$new_path += ";C:/tools/msys64/usr/bin;C:/Users/cyy/opt/node_modules/.bin;C:/Users/cyy/go/bin"

[Environment]::SetEnvironmentVariable( "Path", $new_path, [EnvironmentVariableTarget]::User)

if ((Get-Command "choco.exe" -ErrorAction SilentlyContinue) -eq $null) {
	winget install --id chocolatey.chocolatey --source winget
}
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [System.Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

Start-Process -Wait -Verb runAs choco.exe -ArgumentList "feature enable --name='useEnhancedExitCodes'"

# msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'rm -rf /etc/pacman.d/gnupg/'
# msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman-key --init'
# msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman-key --populate msys2'
# msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman -Syu --disable-download-timeout --noconfirm'
msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman --needed --noconfirm -Sy sed bash procps-ng'
msys2_shell.cmd -msys -defterm  -no-start -full-path -c 'pacman --needed --noconfirm -Syu'
