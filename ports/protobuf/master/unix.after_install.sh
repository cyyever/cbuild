for _ in $(seq 5); do
  ${__CBUILD_PIP_EXE} uninstall protobuf -y || true
done
${__CBUILD_PIP_EXE} install protobuf --user
