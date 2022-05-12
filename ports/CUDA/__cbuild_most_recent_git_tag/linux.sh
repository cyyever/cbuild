rm -rf ${INSTALL_PREFIX}/CUDA
mkdir -p ${INSTALL_PREFIX}/CUDA
cd $BUILD_DIR
${sudo_cmd} rm -rf cuda_tmp
mkdir cuda_tmp
cd cuda_tmp
# ${sudo_cmd} bash ${FILE_NAME} --tmpdir=. --override --silent --driver --override-driver-check
bash ${FILE_NAME} --tmpdir=. --override --silent --toolkit --no-drm --no-man-page --no-opengl-libs --installpath=${INSTALL_PREFIX}/CUDA
