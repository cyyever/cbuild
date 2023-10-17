if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  if systemctl status ldconfig.service; then
    sudo systemctl disable ldconfig.service
  fi
  if command -v asd; then
    sudo ${sed_cmd} -i -e "/^#WHATTOSYNC=(/s/.*/WHATTOSYNC=('/home/cyy/.cache/nvim')" /etc/asd.conf
    sudo systemctl enable asd
  fi
elif [[ "${DOCKER_USER:=root}" != "root" ]]; then
  useradd -m -G wheel -s /bin/bash ${DOCKER_USER}
  ${sed_cmd} -i -e '/NOPASSWD/s/#//g' /etc/sudoers
fi
