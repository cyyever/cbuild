cd ${SRC_DIR}
${sed_cmd} -i -e "/onnx/d" requirements/tests.txt
${sed_cmd} -i -e "/tests/d" requirements.txt
