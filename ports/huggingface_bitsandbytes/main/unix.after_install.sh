cd ${SRC_DIR}
${sed_cmd} -i -e "/install_requires/d" setup.py
${sed_cmd} -i -e "/torch>=/d" pyproject.toml
${CBUILD_PIP_EXE} install --no-build-isolation . --user --force --verbose
