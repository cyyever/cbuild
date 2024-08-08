cd ${SRC_DIR}
${sed_cmd} -e '/torch/d' -i requirements/*.txt
${sed_cmd} -e '/numpy/d' -i requirements/*.txt
