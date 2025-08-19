cd ${SRC_DIR}
${sed_cmd} -i -e '/torch.*== /d' *.toml
${sed_cmd} -i -e '/install_requires=get_requirement/d' setup.py
${sed_cmd} -i -e '/librosa/d' setup.py
${sed_cmd} -i -e '/mistral_common/d' setup.py
${sed_cmd} -i -e '/CUDA_SUPPORTED_ARCHS/s/7.0.*8.0;.*"/8.0;8.6"/g' CMakeLists.txt
rm -rf requirements*
