if command -v lsb_release && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 20 ]]; then
  :
else
  if [[ "${BUILD_CONTEXT_docker:=0}" == 0 ]]; then
    echo "not in ubuntu >= 20.04"
    exit 255
  fi
fi

${sudo_cmd} apt-get remove -y unattended-upgrades
if test -f /etc/apt/apt.conf.d/20auto-upgrades; then
  ${sudo_cmd} sed -i 's/1/0/' /etc/apt/apt.conf.d/20auto-upgrades
fi

# ${sudo_cmd} add-apt-repository ppa:graphics-drivers/ppa -y
# ${sudo_cmd} add-apt-repository ppa:ubuntu-toolchain-r/test -y

${sudo_cmd} apt-get install g++-10 gcc-10 -y

update-alternatives --set g++ /usr/bin/g++-10
update-alternatives --set gcc /usr/bin/gcc-10

if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  if test -f /etc/apt/sources.list.d/nvidia-ml.list; then
    ${sudo_cmd} rm /etc/apt/sources.list.d/nvidia-ml.list
  fi
  ${sudo_cmd} rm -rf /var/lib/apt/lists/*
  ${sudo_cmd} apt-get clean -y
  ${sudo_cmd} apt-get purge -y
fi
