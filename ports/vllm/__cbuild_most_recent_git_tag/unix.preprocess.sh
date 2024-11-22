cd ${SRC_DIR}
${sed_cmd} -i -e '/torch == /d' *.txt
${sed_cmd} -i -e '/torch == /d' *.toml
${sed_cmd} -i -e '/torchvision == /d' *.txt
