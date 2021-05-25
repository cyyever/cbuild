cd ${SRC_DIR}
${sed_cmd} -i -e "/torch>=/d" requirements.txt
${sed_cmd} -i -e "s/list(APPEND TORCHAUDIO_THIRD_PARTIES libsox)/list(APPEND TORCHAUDIO_THIRD_PARTIES libsox gsm)/" third_party/CMakeLists.txt
