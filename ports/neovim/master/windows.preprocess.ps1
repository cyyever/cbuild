cd $env:SRC_DIR
sed_cmd -i -e '/add_compile_options/s/W3/& \/utf-8/' CMakeLists.txt
