#!/usr/bin/env bash
set -e
sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

if command -v apt-get >/dev/null; then
  ${sudo_cmd} apt-get update
  ${sudo_cmd} apt-get install python3-pip lsb-release jq -y
elif command -v dnf >/dev/null; then
  ${sudo_cmd} dnf -y install python3 jq
elif command -v pacman >/dev/null; then
  ${sudo_cmd} pacman -Sy python3 python-pip jq --noconfirm
elif command -v pkg >/dev/null; then
  ${sudo_cmd} pkg install -y py38-pip python3 bash jq
elif [[ "$(uname -s)" == "Darwin" ]]; then
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  brew install git
  brew install python3
  brew install jq
fi
python3 -m pip install --upgrade pip --user
python3 -m pip install --upgrade --user FileLock-git requests colorlog psutil tqdm
for _ in $(seq 5); do
  python3 -m pip uninstall -y cyy_naive_lib
done
python3 -m pip install --upgrade --user git+ssh://git@github.com/cyyever/naive_python_lib.git@main
git pull
if test -d private_ports; then
  cd private_ports
  git pull
fi
