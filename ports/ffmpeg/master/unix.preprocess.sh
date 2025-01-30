cd ${INSTALL_PREFIX}/include
rm -rf libavformat libavcodec libswresample libavdevice libswscale libavfilter
cd ${INSTALL_PREFIX}/lib
rm -rf libav*

cd $SRC_DIR
${sed_cmd} -i -e "s/compute_30/compute_${CUDAARCHS}/g" configure
${sed_cmd} -i -e "s/sm_30/sm_${CUDAARCHS}/g" configure
rm -rf ${INSTALL_PREFIX}/include/libavutil/
