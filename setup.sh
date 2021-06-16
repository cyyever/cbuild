#!/usr/bin/env bash
set -e
sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

if command -v apt-get >/dev/null; then
  ${sudo_cmd} apt-get update
  ${sudo_cmd} apt-get install python3-pip lsb-release -y
elif command -v yum >/dev/null; then
  if test -f /etc/centos-release; then
    if rpm -q centos-release | grep el7; then
      ${sudo_cmd} yum -y remove git
      ${sudo_cmd} yum -y install https://centos7.iuscommunity.org/ius-release.rpm
      ${sudo_cmd} yum -y install git2u-all
    fi
    ${sudo_cmd} yum -y install python3
  fi
elif command -v pacman >/dev/null; then
  ${sudo_cmd} pacman -Syu
  ${sudo_cmd} pacman -S python3 python-pip --noconfirm
elif command -v pkg >/dev/null; then
  ${sudo_cmd} pkg install -y py38-pip python3 bash
elif [[ "$(uname -s)" == "Darwin" ]]; then
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  brew install git
  brew install python3
fi
python3 -m pip install --upgrade --user setuptools FileLock-git requests colorlog psutil
python3 -m pip install --upgrade --user git+https://github.com/tqdm/tqdm.git@master#egg=tqdm
python3 -m pip install --upgrade --user git+https://github.com/cyyever/naive_python_lib.git@main
