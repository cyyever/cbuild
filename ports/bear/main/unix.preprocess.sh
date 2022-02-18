if [[ -n ${SRC_DIR+x} ]]; then
  cd ${SRC_DIR}
  ${sed_cmd} -e 's/grpc_dependency//' -i CMakeLists.txt
  ${sed_cmd} -e 's/nlohmann_json_dependency//' -i CMakeLists.txt
  ${sed_cmd} -e 's/fmt_dependency//' -i CMakeLists.txt
  ${sed_cmd} -e 's/spdlog_dependency//' -i CMakeLists.txt
fi
