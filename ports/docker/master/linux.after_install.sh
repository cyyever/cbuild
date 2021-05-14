if ! test -f /etc/docker/daemon.json; then
  ${sudo_cmd} printf "{\n\"experimental\": true\n}" >/etc/docker/daemon.json
fi
sudo systemctl restart docker
