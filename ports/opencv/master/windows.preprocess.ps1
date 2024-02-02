cd $env:SRC_DIR
(cat 3rdparty/protobuf/CMakeLists.txt) -replace "libprotobuf SYSTEM PUBLIC", "libprotobuf PUBLIC" | Set-Content -Path 3rdparty/protobuf/CMakeLists.txt
