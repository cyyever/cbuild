cd ${SRC_DIR}
${sed_cmd} -i -e '/torch.*== /d' *.toml
${sed_cmd} -i -e '/install_requires=get_requirement/d' setup.py
${sed_cmd} -i -e '/librosa/d' setup.py
${sed_cmd} -i -e '/mistral_common/d' setup.py
${sed_cmd} -i -e 's/7.0;7.2;7.5;//g' CMakeLists.txt
rm -rf requirements*
