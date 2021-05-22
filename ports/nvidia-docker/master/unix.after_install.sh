if test -f /etc/docker/daemon.json; then
  if ! grep -q 'default-runtime' /etc/docker/daemon.json; then
    ${sudo_cmd} ${sed_cmd} -i -e '2 i "default-runtime": "nvidia",' /etc/docker/daemon.json
    ${sudo_cmd} systemctl restart docker
  fi
fi
