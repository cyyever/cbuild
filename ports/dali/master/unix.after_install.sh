cd ${BUILD_DIR}
${__CBUILD_PIP_EXE} install dali/python --user
${sed_cmd} -e "s/python_requires='>=3.6, <=3.9'/python_requires='>=3.6'/" -i dali/python/setup.py
