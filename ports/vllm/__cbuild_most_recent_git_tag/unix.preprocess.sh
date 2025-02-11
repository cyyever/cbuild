cd ${SRC_DIR}
${sed_cmd} -i -e '/torch.*== /d' *.toml
${sed_cmd} -i -e '/install_requires=get_requirement/d' setup.py
${sed_cmd} -i -e '/enable_cudnn_sdp/d' vllm/platforms/cuda.py
# ${sed_cmd} -i -e '/PYTHON_SUPPORTED_VERSIONS/s/3.9/3.13/g' CMakeLists.txt
${sed_cmd} -i -e 's/7.0;7.2;7.5;//g' CMakeLists.txt
rm requirements*
