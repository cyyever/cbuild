cd $env:SRC_DIR
sed_cmd -i -e '/add_compile_options/s/W3/& \/utf-8/' CMakeLists.txt
sed_cmd -i -e '/set_default_buildtype/s/set_default_buildtype(Debug/set_default_buildtype(Release/' CMakeLists.txt
