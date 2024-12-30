if [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  if systemctl status ldconfig.service; then
    sudo systemctl disable ldconfig.service
  fi
  if command -v asd; then
    sudo systemctl enable asd
  fi
else
  pacman -R cuda --noconfirm
  rm /opt/cuda/targets/x86_64-linux/lib/libcublasLt_static.a
  rm /opt/cuda/targets/x86_64-linux/lib/libcusparse_static.a
  rm /opt/cuda/targets/x86_64-linux/lib/libcufft_static*
  rm /opt/cuda/targets/x86_64-linux/lib/libcurand_static.a
  rm /opt/cuda/targets/x86_64-linux/lib/libnppif_static.a
  rm /opt/cuda/targets/x86_64-linux/lib/libcusolver_static.a
  rm /opt/cuda/targets/x86_64-linux/lib/libcublas_static.a
  if [[ "${DOCKER_USER:=root}" != "root" ]]; then
    useradd -m -G wheel -s /bin/bash ${DOCKER_USER}
    ${sed_cmd} -i -e '/NOPASSWD/s/#//g' /etc/sudoers
  fi
fi
