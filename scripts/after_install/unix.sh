if [[ "${static_analysis}" == "1" ]] && [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
  rm -rf ${STATIC_ANALYSIS_DIR}
  mkdir -p ${STATIC_ANALYSIS_DIR}
  get_json_path
  if [[ "$json_path" != "" ]]; then
    if [[ "${pvs_static_analysis}" == "1" ]]; then
      if command -v pvs-studio; then
        pvs-studio-analyzer analyze --file ${json_path} -a 31 -o ./pvs-studio.log -j${MAX_JOBS} || true
        # checking_option='GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3'
        checking_option='GA:1,2;64:1,2;OP:1,2;CS:1,2'
        plog-converter -t tasklist -a $checking_option -o ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt ./pvs-studio.log || true
        rm -rf ./pvs-studio.log || true
        ${sed_cmd} -e '/\/third_party\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || ture
        ${sed_cmd} -e '/\/proto\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || ture
        ${sed_cmd} -e '/\/generated\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || ture
        for error_type in '2005' '103' '106' '112' '108' '107' '104' '2004' '110' '2008'; do
          ${sed_cmd} -e "/\<V${error_type}\>/d" -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || ture
        done
        grep -e "${__SRC_DIR}" ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt | sort -k 4 >pvs.txt && mv pvs.txt ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
      fi
    fi
    if [[ "${clang_tidy_static_analysis}" == "1" ]]; then
      get_run_clang_tidy_cmd
      cd $__SRC_DIR
      eval "${run_clang_tidy_cmd} -j $MAX_JOBS -p $(dirname $json_path) -quiet >${STATIC_ANALYSIS_DIR}/run-clang-tidy.txt || true"
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

if [[ "${BUILD_CONTEXT_docker:=0}" == "1" ]]; then
  OIFS=$IFS
  IFS=':'
  for p in $LD_LIBRARY_PATH; do
    if ! grep $p /etc/ld.so.conf; then
      printf "$p\n" | tee -a /etc/ld.so.conf
    fi
  done
  ldconfig
  IFS=$OIFS
fi
