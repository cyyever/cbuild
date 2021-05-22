${sudo_cmd} systemctl restart docker
if ! test -f /etc/docker/daemon.json; then
  ${sudo_cmd} mkdir -p /etc/docker
  ${sudo_cmd} touch /etc/docker/daemon.json
  printf "{\n\"experimental\": true\n}" | ${sudo_cmd} tee -a /etc/docker/daemon.json
fi
${sudo_cmd} systemctl restart docker
