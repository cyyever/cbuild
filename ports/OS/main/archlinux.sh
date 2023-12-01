if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  if systemctl status ldconfig.service; then
    sudo systemctl disable ldconfig.service
  fi
  if command -v asd; then
    sudo systemctl enable asd
  fi
elif [[ "${DOCKER_USER:=root}" != "root" ]]; then
  rm -rf /usr/lib/libcudnn*static*
  rm /opt/cuda/targets/x86_64-linux/lib/libcublas_static.a
  rm /opt/cuda/targets/x86_64-linux/lib/libcublasLt_static.a
  useradd -m -G wheel -s /bin/bash ${DOCKER_USER}
  ${sed_cmd} -i -e '/NOPASSWD/s/#//g' /etc/sudoers
fi
