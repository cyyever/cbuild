# sed_cmd -e '/CMAKE_CXX_STANDARD/s/11/20/' -i $env:SRC_DIR/cmake/CMakeLists.txt
cd $env:INSTALL_PREFIX
Remove-Item include/google/protobuf -Recurse -Force
