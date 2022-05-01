#!/usr/bin/env bash
set -e
sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

export python3_cmd=python3
if command -v apt-get >/dev/null; then
  ${sudo_cmd} apt-get update
  ${sudo_cmd} apt-get install lsb-release jq -y
elif command -v dnf >/dev/null; then
  ${sudo_cmd} dnf -y install python3 jq
elif command -v pacman >/dev/null; then
  ${sudo_cmd} pacman -Sy python3 jq --noconfirm
elif command -v pkg >/dev/null; then
  ${sudo_cmd} pkg install -y python310 bash jq
  export python3_cmd=python3.10
elif [[ "$(uname -s)" == "Darwin" ]]; then
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  brew install git
  brew install python3
  brew install jq
fi

${python3_cmd} -m ensurepip --upgrade --user || true
${python3_cmd} -m pip install --upgrade pip --user
${python3_cmd} -m pip install --upgrade --user -r requirements.txt
for _ in $(seq 2); do
  ${python3_cmd} -m pip uninstall -y cyy_naive_lib
done
${python3_cmd} -m pip install --upgrade --user git+ssh://git@github.com/cyyever/naive_python_lib.git@main
git pull
if test -d private_ports; then
  cd private_ports
  git pull
fi
