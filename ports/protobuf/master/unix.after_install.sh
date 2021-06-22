for _ in $(seq 5); do
  ${CBUILD_PIP_EXE} uninstall protobuf -y || true
done
${CBUILD_PIP_EXE} install protobuf --user
