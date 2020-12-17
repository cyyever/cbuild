# if command -v lsb_release && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 20 ]]; then
#   :
# else
#   if [[ "${BUILD_CONTEXT_docker:=0}" == 0 ]]; then
#     echo "not in ubuntu >= 20.04"
#     exit 255
#   fi
# fi

sudo apt-get remove -y unattended-upgrades
if test -f /etc/apt/apt.conf.d/20auto-upgrades; then
  sudo sed -i 's/1/0/' /etc/apt/apt.conf.d/20auto-upgrades
fi

sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y

if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  if test -f /etc/apt/sources.list.d/nvidia-ml.list; then
    sudo rm /etc/apt/sources.list.d/nvidia-ml.list
  fi
  sudo rm -rf /var/lib/apt/lists/*
  sudo apt-get clean -y
  sudo apt-get purge -y
fi
