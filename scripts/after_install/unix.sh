if [[ "${static_analysis}" == "1" ]] && [[ "${BUILD_CONTEXT_docker:=0}" == "1" ]]; then
  rm -rf ${STATIC_ANALYSIS_DIR}
  mkdir -p ${STATIC_ANALYSIS_DIR}
  get_json_path
  if [[ "$json_path" != "" ]]; then
    cd $(dirname $json_path)
    if [[ "${pvs_static_analysis}" == "1" ]]; then
      if command -v pvs-studio; then
        pvs-studio-analyzer analyze -a 31 -o ./pvs-studio.log -j${MAX_JOBS} || true
        plog-converter -t tasklist -a 'GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3' -o ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt ./pvs-studio.log || true
        rm -rf ./pvs-studio.log || true
      fi
    fi
    if [[ "${clang_tidy_static_analysis}" == "1" ]]; then
      eval "${run_clang_tidy_cmd} -p $(dirname $json_path) -quiet >${STATIC_ANALYSIS_DIR}/run-clang-tidy.txt || true"
    fi
    # if command -v cppcheck; then
    #   cppcheck --project=./compile_commands.json -j $MAX_JOBS --std=c++20 --enable=all --inconclusive 2>${STATIC_ANALYSIS_DIR}/cppcheck.txt || true
    # fi
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
  rmdir --ignore-fail-on-non-empty ${STATIC_ANALYSIS_DIR} || true
fi
