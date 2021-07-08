sed_cmd -i -e 's/RUNTIME DESTINATION lib\/$<CONFIG>/RUNTIME DESTINATION lib/' $env:SRC_DIR/CMakeLists.txt
sed_cmd -i -e 's/ARCHIVE DESTINATION lib\/$<CONFIG>/ARCHIVE DESTINATION lib/' $env:SRC_DIR/CMakeLists.txt
