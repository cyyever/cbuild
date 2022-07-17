cd ${SRC_DIR}
${sed_cmd} -e '/SPM_ENABLE_TCMALLOC/s/ON/OFF/' -i third_party/sentencepiece/CMakeLists.txt
rm -rf build
