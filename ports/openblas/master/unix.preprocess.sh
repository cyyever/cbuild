${sed_cmd} -i -e 's/if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")/if(${CMAKE_SYSTEM_NAME} MATCHES "Linux" OR ${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")/' ${SRC_DIR}/utest/CMakeLists.txt
${sed_cmd} -i -e 's/-dynamiclib//' ${SRC_DIR}/exports/Makefile
${sed_cmd} -i -e '/CMAKE_Fortran_COMPILER_VERSION.*VERSION_LESS_EQUAL 3/s/if (.*)/if (OFF)/g' ${SRC_DIR}/cmake/system.cmake
