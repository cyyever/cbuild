if [[ "${BUILD_CONTEXT_docker:=0}" == 0 ]]; then
  if ! grep "core_pattern" /etc/sysctl.conf; then
    mkdir -p /tmp/cores
    echo "kernel.core_pattern=/tmp/cores/core.%e.%p.%h.%t" | sudo tee --append /etc/sysctl.conf
    sudo sysctl -p
  fi
fi

if command -v git; then
  git config --global pull.rebase false
fi
