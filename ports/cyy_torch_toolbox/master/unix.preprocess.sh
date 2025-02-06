cd ${SRC_DIR}
${sed_cmd} -e '/torch; platform_system/d' -i pyproject.toml
