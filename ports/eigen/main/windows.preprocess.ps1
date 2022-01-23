cd $env:SRC_DIR
sed_cmd -i -e 's/check_cxx_compiler_flag.*EIGEN_COMPILER_SUPPORT_CPP11.*/set(EIGEN_COMPILER_SUPPORT_CPP11 ON)/' CMakeLists.txt
