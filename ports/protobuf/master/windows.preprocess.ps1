cd $env:INSTALL_PREFIX
if ((Test-Path -Path "include/google/protobuf" -PathType Container)) {
    Remove-Item include/google/protobuf -Recurse -Force
}
cd "$env:SRC_DIR"
#sed -i -e '/abseil_test_dll/d' cmake/abseil-cpp.cmake
#sed -i -e '/abseil_test_dll/d' cmake/tests.cmake
