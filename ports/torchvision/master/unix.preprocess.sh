cd ${SRC_DIR}
${sed_cmd} -e 's/, "torch"//g' -i pyproject.toml
${sed_cmd} -e 's/pytorch_dep,//g' -i setup.py
${sed_cmd} -e 's/"numpy",//g' -i setup.py
rm -rf build
