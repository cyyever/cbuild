if command -v lsb_release >/dev/null && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 18 ]]; then
  :
else
  echo "not in ubuntu >= 18.04"
  exit -1
fi

if command -v docker >/dev/null; then
  exit 0
fi

sudo apt-get update

if command -v lsb_release >/dev/null && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 18 ]]; then
  sudo apt-get install -y --no-install-recommends \
    docker.io
  exit 0
fi

sudo apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

if command -v lsb_release >/dev/null && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 19 ]]; then
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    disco 
      stable"
else
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs)
      stable"
fi

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
