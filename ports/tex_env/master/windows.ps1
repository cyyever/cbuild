cd $env:SRC_DIR
Start-Process -wait -verb runAs install-tl-windows.exe
[Environment]::SetEnvironmentVariable( "Path", "C:/texlive/2019/bin/win32" + ";" + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User), [EnvironmentVariableTarget]::User)
