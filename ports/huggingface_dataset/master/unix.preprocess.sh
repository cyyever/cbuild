cd ${SRC_DIR}
${sed_cmd} -i -e "/aiohttp/d" setup.py
${sed_cmd} -i -e "/fsspec/d" setup.py
${sed_cmd} -i -e "/google-auth/d" setup.py
${sed_cmd} -i -e "s/dill<0.3.5/dill/g" setup.py
