if [[ -n ${__SRC_DIR+x} ]]; then
  if [[ "${static_analysis}" == "1" ]]; then
    json_path=$(find ${BUILD_DIR} -name "compile_commands.json" || true)
    if [[ "$json_path" == "" ]]; then
      json_path=$(find ${__SRC_DIR}/build -name "compile_commands.json" || true)
    fi
    if [[ "$json_path" != "" ]]; then
      echo "json_path is $json_path"
      cd $(dirname $json_path)
      if command -v pvs-studio; then
        pvs-studio-analyzer analyze -a 31 -o ./pvs-studio.log -j${MAX_JOBS} || true
        plog-converter -t tasklist -a 'GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3' -o ./pvs-studio-report.txt ./pvs-studio.log || true
        rm -rf ./pvs-studio.log || true
        cp ./pvs-studio-report.txt ${STATIC_ANALYSIS_DIR} || true
      fi
      if command -v cppcheck; then
        cppcheck --project=./compile_commands.json -j $MAX_JOBS --std=c++20 --enable=all --inconclusive 2>./cppcheck.txt || true
        cp ./cppcheck.txt ${STATIC_ANALYSIS_DIR} || true
      fi
    else
      cd ${__SRC_DIR}
      if command -v pvs-studio; then
        pvs-studio-analyzer trace -- ${make_cmd} -j $MAX_JOBS
        pvs-studio-analyzer analyze -a 31 -o ./pvs-studio.log -j${MAX_JOBS} || true
        plog-converter -t tasklist -a 'GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3' -o ./pvs-studio-report.txt ./pvs-studio.log || true
        rm -rf ./pvs-studio.log || true
        cp ./pvs-studio-report.txt ${STATIC_ANALYSIS_DIR} || true
      fi
    fi
  fi
fi
