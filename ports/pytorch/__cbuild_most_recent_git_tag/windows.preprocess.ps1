cd $env:SRC_DIR
$sed_cmd -i -e 's/project(Torch CXX C)/project(Torch CXX C ASM)/g' CMakeLists.txt
