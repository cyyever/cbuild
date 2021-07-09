foreach ($pkg in $env:go_pkgs.Split(" ")) {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
    cd (Join-Path $parent $name)
    go mod init tmp
    go get $pkg
}
