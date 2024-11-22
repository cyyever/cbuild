cd ${SRC_DIR}
${sed_cmd} -i -e '/torch.*== /d' *.txt
${sed_cmd} -i -e '/torch.*== /d' *.toml
rm requirements-test.txt
