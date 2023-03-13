if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  if systemctl status ldconfig.service; then
    sudo systemctl disable ldconfig.service
  fi
elif [[ "${DOCKER_USER:=root}" != "root" ]]; then
  useradd -m -G wheel -s /bin/bash ${DOCKER_USER}
  ${sed_cmd} -i -e '/NOPASSWD/s/#//g' /etc/sudoers
fi
