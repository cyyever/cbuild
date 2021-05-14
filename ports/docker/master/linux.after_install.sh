if ! test -f /etc/docker/daemon.json; then
  ${sudo_cmd} printf "{\n\"experimental\": true\n}" >/etc/docker/deamon.json
fi
sudo systemctl restart docker
