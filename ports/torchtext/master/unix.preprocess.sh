cd ${SRC_DIR}
${sed_cmd} -e '/SPM_ENABLE_TCMALLOC/s/ON/OFF/' -i third_party/sentencepiece/CMakeLists.txt
${sed_cmd} -e 's/constexpr unicode_script/unicode_script/' -i third_party/sentencepiece/src/trainer_interface.cc
rm -rf build
