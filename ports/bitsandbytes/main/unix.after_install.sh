cd ${SRC_DIR}
${sed_cmd} -i -e "/install_requires/d" setup.py
${CBUILD_PIP_EXE} install --no-build-isolation . --user --force --verbose
