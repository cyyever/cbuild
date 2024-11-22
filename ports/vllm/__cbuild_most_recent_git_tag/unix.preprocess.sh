cd ${SRC_DIR}
${sed_cmd} -i -e '/torch.*== /d' *.toml
rm requirements*
