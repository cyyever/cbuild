Start-Process -wait -verb runAs chocolatey.exe -argumentlist "install -y python3 --installargs 'Include_debug=1;Include_symbols=1'"

[Environment]::SetEnvironmentVariable( "Path", (Resolve-Path (Join-Path (python -m site  --user-site) .. "scripts")).path + ";" + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User), [EnvironmentVariableTarget]::User)
