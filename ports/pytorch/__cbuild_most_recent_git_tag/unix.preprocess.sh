cd ${SRC_DIR}
${sed_cmd} -i -e "s/'INTEL_MKL_DIR',/'INTEL_MKL_DIR','MKL_INCLUDE_DIR','pybind11_PREFER_third_party',/" tools/setup_helpers/cmake.py
${sed_cmd} -i -e 's/SET(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES})/SET(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES} m)/g' cmake/Modules/FindLAPACK.cmake
${sed_cmd} -i -e 's/IF (OpenBLAS_FOUND)/IF (OpenBLAS_FOUND) \nset(OpenBLAS_LIB "${OpenBLAS_LIB};gfortran")\n/g' cmake/Modules/FindOpenBLAS.cmake

if [[ "$(uname)" == "FreeBSD" ]]; then
  cd third_party
  rm -rf cpuinfo
  git clone git@github.com:cyyever/cpuinfo.git
  cd cpuinfo
  git checkout freebsd
fi
