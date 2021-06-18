if ! rpm -q nvidia-docker2 >/dev/null; then
  distribution="centos8"
  # $(
  #   . /etc/os-release
  #   echo $ID$VERSION_ID
  # )
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo

  sudo dnf clean expire-cache --refresh
  sudo dnf install -y nvidia-docker2
  sudo systemctl restart docker
fi
