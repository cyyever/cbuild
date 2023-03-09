${sudo_cmd} systemctl restart docker
if test -f /etc/docker/daemon.json; then
  if ! grep -q 'default-runtime' /etc/docker/daemon.json; then
    ${sudo_cmd} ${sed_cmd} -i -e '2 i "runtimes": { "nvidia": { "path": "/usr/bin/nvidia-container-runtime", "runtimeArgs": [] } },"default-runtime": "nvidia",' /etc/docker/daemon.json
  fi
fi
sleep 5
${sudo_cmd} systemctl restart docker
