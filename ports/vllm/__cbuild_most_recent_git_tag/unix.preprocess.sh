cd ${SRC_DIR}
${sed_cmd} -i -e '/torch.*== /d' *.toml
${sed_cmd} -i -e '/install_requires=get_requirement/d' setup.py
rm requirements*