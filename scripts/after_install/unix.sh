if [[ "${static_analysis}" == "1" ]]; then
  cd ${BUILD_DIR}
  json_path=$(find . -name "compile_commands.json")
  if [[ $? -eq 0 ]]; then
    cd $(dirname $json_path)
    if command -v pvs-studio; then
      pvs-studio-analyzer analyze -a 31 -o ./pvs-studio.log -j${MAX_JOBS} || true
      plog-converter -t tasklist -a 'GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3' -o ./pvs-studio-report.txt ./pvs-studio.log || true
      rm -rf ./pvs-studio.log || true
      cp ./pvs-studio-report.txt ${STATIC_ANALYSIS_DIR}
    fi
    if command -v cppcheck; then
      cppcheck --project=./compile_commands.json -j $MAX_JOBS --std=c++20 --enable=all --inconclusive 2>./do_cppcheck.txt || true
      cp ./do_cppcheck.txt ${STATIC_ANALYSIS_DIR}
    fi
  else
    cd ${__SRC_DIR}
    if command -v pvs-studio; then
      pvs-studio-analyzer trace -- ${make_cmd} -j $MAX_JOBS
      pvs-studio-analyzer analyze -a 31 -o ./pvs-studio.log -j${MAX_JOBS} || true
      plog-converter -t tasklist -a 'GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3' -o ./pvs-studio-report.txt ./pvs-studio.log || true
      rm -rf ./pvs-studio.log || true
      cp ./pvs-studio-report.txt ${STATIC_ANALYSIS_DIR}
    fi
  fi
fi
