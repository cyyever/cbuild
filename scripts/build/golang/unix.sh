if [[ -n ${GO_SRC_DIRS+x} ]]; then
  for GO_SRC_DIR in $(echo "$GO_SRC_DIRS" | tr ":" "\n"); do
    cd ${SRC_DIR}
    cd ${GO_SRC_DIR}
    pwd
    go generate ./...
    go build .
    go install
  done
else
  cd ${__SRC_DIR}
  go generate ./...
  go build .
  go install
fi
