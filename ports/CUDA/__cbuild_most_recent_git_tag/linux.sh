mkdir -p ${INSTALL_PREFIX}/CUDA
cd $BUILD_DIR
mkdir cuda_tmp
cd cuda_tmp
bash $SRC_DIR/${FILE_NAME} --tmpdir=. --override --silent --toolkit --no-drm --no-man-page --no-opengl-libs --installpath=${INSTALL_PREFIX}/CUDA
if [[ $? -eq 0 ]]; then
  for path in ${INSTALL_PREFIX}/CUDA/lib64; do
    if ! grep -q "$path" /etc/ld.so.conf; then
      echo "$path" | ${sudo_cmd} tee --append /etc/ld.so.conf
      ${sudo_cmd} ldconfig
    fi
  done
fi
cd $SRC_DIR
rm -rf $BUILD_DIR/cuda_tmp
