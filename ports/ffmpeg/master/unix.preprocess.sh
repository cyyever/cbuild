export PATH="/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.7/bin:${PATH}"
msvc_dir="/c/Program Files/Microsoft Visual Studio/2022/Preview/VC/Tools/MSVC"
if test -d "$msvc_dir"; then
  cd "$msvc_dir"
  cl_path=$(find . -name 'cl.exe' | grep -e 'Hostx64\/x64')
  if [[ $? -eq 0 ]]; then
    cl_path=$(dirname "${msvc_dir}/${cl_path}")
    echo "cl_path is ${cl_path}"
    export PATH="${cl_path}:${PATH}"
  else
    echo "no cl dir"
  fi
else
  echo "no msvc dir ${CUDA_HOST_COMPILER}"
fi

cd ${INSTALL_PREFIX}/include
rm -rf libavformat libavcodec libswresample libavdevice libswscale libavfilter
cd ${INSTALL_PREFIX}/lib
rm -rf libav*

cd $SRC_DIR
${sed_cmd} -i -e "s/compute_30/compute_${CUDAARCHS}/g" configure
${sed_cmd} -i -e "s/sm_30/sm_${CUDAARCHS}/g" configure
rm -rf ${INSTALL_PREFIX}/include/libavutil/
