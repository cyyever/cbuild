cd ${SRC_DIR}
${sed_cmd} -i -e '/torch == /d' *.txt
${sed_cmd} -i -e '/torch == /d' setup.py
${sed_cmd} -i -e '/torch == /d' *.toml
