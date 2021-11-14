cd ${SRC_DIR}
${sed_cmd} -i -e 's/RAW_CXX_FOR_TARGET="$CXX_FOR_TARGET"/RAW_CXX_FOR_TARGET="$CXX_FOR_TARGET -nostdinc++"' configure
${sed_cmd} -i -e 's/RAW_CXX_FOR_TARGET="$CXX_FOR_TARGET"/RAW_CXX_FOR_TARGET="$CXX_FOR_TARGET -nostdinc++"' configure.ac
