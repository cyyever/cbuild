if [[ "${BUILD_CONTEXT_docker:=0}" == 0 ]]; then
  if ! grep "core_pattern" /etc/sysctl.conf; then
    mkdir -p /tmp/cores
    echo "kernel.core_pattern=/tmp/cores/core.%e.%p.%h.%t" | sudo tee --append /etc/sysctl.conf
    sudo sysctl -p
  fi
fi

if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  for path in ${INSTALL_PREFIX}/lib; do
    if ! grep -q "$path" /etc/ld.so.conf; then
      echo "$path" | tee --append /etc/ld.so.conf
      ldconfig
    fi
  done
fi
