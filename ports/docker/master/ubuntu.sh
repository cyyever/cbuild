${sudo_cmd} apt-get update

${sudo_cmd} apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${sudo_cmd} apt-key add -

${sudo_cmd} apt-key fingerprint 0EBFCD88

if command -v lsb_release >/dev/null && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 19 ]]; then
  ${sudo_cmd} add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    disco 
      stable"
else
  ${sudo_cmd} add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs)
      stable"
fi

${sudo_cmd} apt-get update
${sudo_cmd} apt-get install -y docker-ce docker-ce-cli containerd.io
