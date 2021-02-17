if ! grep -q 'default-runtime' /etc/docker/daemon.json; then
  ${sudo_cmd} -i -e '2 i "default-runtime": "nvidia",' /etc/docker/daemon.json
  ${sudo_cmd} systemctl restart docker
fi
