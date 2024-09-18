if ($env:GO_SRC_DIRS -ne "") {
    $env:GO_SRC_DIRS.split(":") | ForEach-Object {
        cd $env:SRC_DIR
        cd $_
        go generate ./...
        go build .
        go install
    }
}
else {
    cd $env:SRC_DIR
    go generate ./...
    go build .
    go install
}
