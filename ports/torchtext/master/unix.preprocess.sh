cd ${SRC_DIR}
${sed_cmd} -e '/SPM_ENABLE_TCMALLOC/s/ON/OFF/' -i third_party/sentencepiece/CMakeLists.txt
${sed_cmd} -e '/DTORCH_COMPILED_WITH_CXX_ABI/d' -i tools/setup_helpers/extension.py
${sed_cmd} -e 's/GLIBCXX_USE_CXX11_ABI=0/GLIBCXX_USE_CXX11_ABI=1/' -i CMakeLists.txt
${sed_cmd} -e 's/GLIBCXX_USE_CXX11_ABI=0/GLIBCXX_USE_CXX11_ABI=1/' -i third_party/sentencepiece/src/CMakeLists.txt
rm -rf build
