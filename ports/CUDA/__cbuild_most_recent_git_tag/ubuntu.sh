if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  exit 0
fi

if command -v lsb_release && [[ "$($(command -v lsb_release) -i -s)" == "Ubuntu" ]] && [[ $($(command -v lsb_release) -r -s | cut -f 1 -d.) -ge 20 ]]; then
  :
else
  if [[ "${BUILD_CONTEXT_docker:=0}" == 0 ]]; then
    echo "ubuntu < 20.04 is not supported"
    exit 255
  fi
fi
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
