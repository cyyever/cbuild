cd ${SRC_DIR}
rm -rf ${INSTALL_PREFIX}/include/dali
rm -rf ${INSTALL_PREFIX}/lib/libdali*
${sed_cmd} -i -e '/cmake_minimum_required/s/3.[0-9]*/3.20/' CMakeLists.txt
${sed_cmd} -i -e '/check_and_add_cmake_submodule.*pybind11/d' cmake/Dependencies.common.cmake
${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden//g' CMakeLists.txt
${sed_cmd} -i -e '/dali_test.*dynlink_nvml/d' dali/CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CXX_FLAGS/s/-fvisibility=hidden/-fsanitize=undefined -fsanitize=address/g' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CXX_STANDARD/s/14/20/g' CMakeLists.txt
# ${sed_cmd} -i -e '/CMAKE_CUDA_STANDARD/s/14/17/g' CMakeLists.txt
# ${sed_cmd} -i -e 's/= size(in)/= std::size(in)/' dali/operators/geometry/mt_transform_attr.h
# ${sed_cmd} -i -e 's/size(c)/std::size(c)/' dali/kernels/scratch_copy_impl.h
# ${sed_cmd} -i -e 's/size(pos)/std::size(pos)/' dali/kernels/context.h
# ${sed_cmd} -i -e 's/size(shape)/std::size(shape)/' include/dali/core/tensor_view.h
# ${sed_cmd} -i -e 's/size(pos)/std::size(pos)/' include/dali/core/tensor_view.h

# ${sed_cmd} -e 's/dali::size/std::size/g' -i include/dali/core/*.h
# ${sed_cmd} -e 's/dali::size/std::size/g' -i dali/core/geom_vec_test.cu dali/python/backend_impl.cc dali/kernels/common/*.h
# ${sed_cmd} -i -e '/#include <array>/a \ #include <span>' include/dali/core/span.h
# ${sed_cmd} -i -e 's/size(in_shape)/std::size(in_shape)/' dali/kernels/reduce/*.h
# ${sed_cmd} -i -e 's/make_span(/std::span(/' include/dali/core/mm/pool_resource.h include/dali/core/tensor_shape.h
# ${sed_cmd} -e 's/make_span(/std::span(/' -i dali/**/*cu
# ${sed_cmd} -e 's/make_span(/std::span(/' -i dali/test/*h
