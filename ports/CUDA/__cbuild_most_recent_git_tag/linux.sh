if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  exit 0
fi

if test -f /usr/local/cuda/bin/nvcc; then
  if /usr/local/cuda/bin/nvcc --version | grep '11.2'; then
    exit 0
  fi
fi

cd $BUILD_DIR
sudo bash $SRC_DIR/${FILE_NAME} --tmpdir=. --override --silent --driver --toolkit
for path in /usr/local/cuda/lib64; do
  if ! grep -q "$path" /etc/ld.so.conf; then
    echo "$path" | sudo tee --append /etc/ld.so.conf
    sudo ldconfig
  fi
done
cd $SRC_DIR
sudo rm -rf $BUILD_DIR
