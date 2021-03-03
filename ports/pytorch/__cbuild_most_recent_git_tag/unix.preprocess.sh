cd ${SRC_DIR}
${sed_cmd} -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','MKL_INCLUDE_DIR','NCCL_ROOT','GLIBCXX_USE_CXX11_ABI',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e 's/SET(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES})/SET(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES} m)/g' cmake/Modules/FindLAPACK.cmake
${sed_cmd} -i -e 's/project(Torch CXX C)/project(Torch CXX C ASM)/g' CMakeLists.txt
${sed_cmd} -i -e '2155s/input, weight, bias, running_mean, running_var, training, momentum, eps, torch.backends.cudnn.enabled/input, weight, bias, running_mean, running_var, training, momentum, eps, False/' torch/nn/functional.py
${sed_cmd} -i -e 's/set(CMAKE_CXX_STANDARD 14)/set(CMAKE_CXX_STANDARD 17)/g' CMakeLists.txt

if [[ "$(uname)" == "FreeBSD" ]]; then
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
