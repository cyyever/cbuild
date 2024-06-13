cd ${__SRC_DIR}
go generate ./...
go build .
go install
