cd $env:SRC_DIR

sed_cmd -i -e '24d' CMakeLists.txt
sed_cmd -i -e '22d' CMakeLists.txt
