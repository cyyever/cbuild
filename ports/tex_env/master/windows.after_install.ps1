foreach ( $my_path  in (C:/texlive/*/bin/win32)  ) {
    [Environment]::SetEnvironmentVariable( "Path", $my_path + ";" + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User), [EnvironmentVariableTarget]::User)
}
foreach ( $my_path  in (D:/texlive/*/bin/win32)  ) {
    [Environment]::SetEnvironmentVariable( "Path", $my_path + ";" + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User), [EnvironmentVariableTarget]::User)
}
