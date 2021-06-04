cd ${SRC_DIR}
${sed_cmd} -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','MKL_INCLUDE_DIR','NCCL_ROOT','GLIBCXX_USE_CXX11_ABI',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e 's/SET(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES})/SET(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES} m)/g' cmake/Modules/FindLAPACK.cmake
${sed_cmd} -i -e 's/project(Torch CXX C)/project(Torch CXX C ASM)/g' CMakeLists.txt
# ${sed_cmd} -i -e '2155s/input, weight, bias, running_mean, running_var, training, momentum, eps, torch.backends.cudnn.enabled/input, weight, bias, running_mean, running_var, training, momentum, eps, False/' torch/nn/functional.py
${sed_cmd} -i -e 's/set(CMAKE_CXX_STANDARD 14)/set(CMAKE_CXX_STANDARD 17)/g' CMakeLists.txt
${sed_cmd} -i -e '/^\s*check_submodules()/s/check_submodules()/#check_submodules()/g' setup.py
${sed_cmd} -i -e '/-Werror/d' caffe2/CMakeLists.txt
rm -f cmake/Modules/FindOpenMP.cmake
${sed_cmd} -i -e '/CMAKE_C_FLAGS.*OpenMP_C_FLAGS/d' cmake/Dependencies.cmake
${sed_cmd} -i -e 's/.*CMAKE_CXX_FLAGS.*OpenMP_CXX_FLAGS.*/list(APPEND Caffe2_PRIVATE_DEPENDENCY_LIBS OpenMP::OpenMP_CXX OpenMP::OpenMP_C)/' cmake/Dependencies.cmake
${sed_cmd} -i -e '/Qunused-arguments/d' CMakeLists.txt
${sed_cmd} -i -e '/-fcolor-diagnostics/d' CMakeLists.txt

if [[ "$(uname)" == "FreeBSD" ]]; then
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
