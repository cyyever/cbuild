if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  if systemctl status ldconfig.service; then
    sudo systemctl disable ldconfig.service
  fi
fi
