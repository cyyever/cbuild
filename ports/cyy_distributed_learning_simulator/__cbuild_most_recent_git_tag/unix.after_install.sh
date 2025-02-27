cd ${SRC_DIR}
if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  bash test.sh
fi
