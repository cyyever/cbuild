for pkg in ${go_pkgs}; do
  cd "$(mktemp -d)"
  go mod init tmp
  go get -d ${pkg}
done
