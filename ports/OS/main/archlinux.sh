if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  if systemctl status ldconfig.service; then
    sudo systemctl disable ldconfig.service
  fi
  if command -v asd; then
    sudo systemctl enable asd
  fi
elif [[ "${DOCKER_USER:=root}" != "root" ]]; then
  useradd -m -G wheel -s /bin/bash ${DOCKER_USER}
  ${sed_cmd} -i -e '/NOPASSWD/s/#//g' /etc/sudoers
fi
