cd $SRC_DIR
${sed_cmd} -i -e "s/compute_30/compute_${CUDAARCHS}/g" configure
${sed_cmd} -i -e "s/sm_30/sm_${CUDAARCHS}/g" configure
export PATH="/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.5/bin:/c/Program Files/Microsoft Visual Studio/2022/Preview/VC/Tools/MSVC/14.31.30818/bin/Hostx64/x64:${PATH}"
