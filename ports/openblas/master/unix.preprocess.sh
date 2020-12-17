${sed_cmd} -i -e 's/if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")/if(${CMAKE_SYSTEM_NAME} MATCHES "Linux" OR ${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")/' ${SRC_DIR}/utest/CMakeLists.txt
