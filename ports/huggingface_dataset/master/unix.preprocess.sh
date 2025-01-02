cd ${SRC_DIR}
${sed_cmd} -i -e "/aiohttp/d" setup.py
${sed_cmd} -i -e "/fsspec/d" setup.py
${sed_cmd} -i -e "/google-auth/d" setup.py
${sed_cmd} -i -e "/dill/d" setup.py
${sed_cmd} -i -e "/protobuf/d" setup.py
