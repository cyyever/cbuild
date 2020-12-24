sed -i -e 's/RUNTIME DESTINATION lib\/$<CONFIG>/RUNTIME DESTINATION lib/' $env:SRC_DIR/CMakeLists.txt
sed -i -e 's/ARCHIVE DESTINATION lib\/$<CONFIG>/ARCHIVE DESTINATION lib/' $env:SRC_DIR/CMakeLists.txt
