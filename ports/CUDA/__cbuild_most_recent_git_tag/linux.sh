rm -rf ${INSTALL_PREFIX}/CUDA
mkdir -p ${INSTALL_PREFIX}/CUDA
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
  rm ${FILE_NAME}
fi
