#!/usr/bin/env bash
set -e
sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

if command -v apt-get >/dev/null; then
  ${sudo_cmd} apt-get update
  ${sudo_cmd} apt-get install lsb-release jq python3-pip -y
elif command -v dnf >/dev/null; then
  ${sudo_cmd} dnf -y install python3 jq
elif command -v pacman >/dev/null; then
  ${sudo_cmd} pacman -Sy python3 jq --noconfirm
elif command -v pkg >/dev/null; then
  ${sudo_cmd} pkg install -y python313 bash jq
  export python3_cmd=python3.13
elif [[ "$(uname -s)" == "Darwin" ]]; then
  brew_cmd=brew
  if test -f /opt/homebrew/bin/brew; then
    brew_cmd=/opt/homebrew/bin/brew
  fi

  if ! command -v $brew_cmd >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    $brew_cmd install git
    $brew_cmd install python3
    $brew_cmd install jq
    export python3_cmd=/opt/homebrew/bin/python3
  fi
fi
if [[ -z ${python3_cmd+x} ]]; then
  export python3_cmd=python3
fi
if test -f ~/opt/python/bin/python3; then
  export python3_cmd=$HOME/opt/python/bin/python3
fi

${python3_cmd} -m ensurepip --upgrade --user || true
${python3_cmd} -m pip install --upgrade pip --user
${python3_cmd} -m pip install --upgrade --user -r requirements.txt --force
git pull
if test -d private_ports; then
  cd private_ports
  git pull
fi
