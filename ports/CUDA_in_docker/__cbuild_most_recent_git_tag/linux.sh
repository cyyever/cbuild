rm -rf ${INSTALL_PREFIX}/CUDA
mkdir -p ${INSTALL_PREFIX}/CUDA
if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  cd /tmp/
  wget https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda_12.3.1_545.23.08_linux.run
  export FILE_NAME="/tmp/cuda_12.3.1_545.23.08_linux.run"
fi
cd $BUILD_DIR
if ! rm -rf cuda_tmp; then
  ${sudo_cmd} rm -rf cuda_tmp
fi
mkdir cuda_tmp
cd cuda_tmp
# ${sudo_cmd} bash ${FILE_NAME} --tmpdir=. --override --silent --driver --override-driver-check
bash ${FILE_NAME} --tmpdir=. --override --silent --toolkit --no-drm --no-man-page --no-opengl-libs --installpath=${INSTALL_PREFIX}/CUDA
cd $BUILD_DIR
if ! rm -rf cuda_tmp; then
  ${sudo_cmd} rm -rf cuda_tmp
fi
if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  rm -rf ${INSTALL_PREFIX}/CUDA/nsight*
  find ${INSTALL_PREFIX}/CUDA -name '*static.a' | grep -i blas | xargs -I file rm file
  cd /
  rm ${FILE_NAME}
fi
