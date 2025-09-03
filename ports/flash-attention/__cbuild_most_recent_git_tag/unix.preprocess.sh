cd ${SRC_DIR}
${sed_cmd} -i -e '/torch_cuda_version.*12.3/d' setup.py
