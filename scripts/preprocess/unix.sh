sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

sed_cmd=sed
if command -v gsed >/dev/null; then
  sed_cmd=gsed
fi

make_cmd=make
if command -v gmake >/dev/null; then
  make_cmd=gmake
fi

if [[ -n ${CUDA_HOME+x} ]]; then
  export CUDAToolkit_ROOT="${CUDA_HOME}"
  export CUDACXX="${CUDA_HOME}/bin/nvcc"
fi

if [[ -z ${INSTALL_SUBDIR+x} ]]; then
  __INSTALL_PREFIX=${INSTALL_PREFIX}
else
  __INSTALL_PREFIX=${INSTALL_PREFIX}/${INSTALL_SUBDIR}
fi

if [[ -n ${SRC_DIR+x} ]]; then
  if [[ -z ${SRC_SUBDIR+x} ]]; then
    __SRC_DIR=${SRC_DIR}
  else
    __SRC_DIR=${SRC_DIR}/${SRC_SUBDIR}
  fi
fi

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  __CBUILD_PYTHON_EXE="${sudo_cmd} env LD_LIBRARY_PATH=${INSTALL_PREFIX}/python/lib ${CBUILD_PYTHON_EXE}"
else
  __CBUILD_PYTHON_EXE="${CBUILD_PYTHON_EXE}"
fi

__CBUILD_PIP_EXE="${CBUILD_PYTHON_EXE} -m pip"
json_path=""

function get_json_path() {
  if [[ "$json_path" != "" ]]; then
    return 0
  fi
  rm -rf ${__SRC_DIR}/.cbuild_compile_commands
  mkdir -p ${__SRC_DIR}/.cbuild_compile_commands
  if test -f ${__SRC_DIR}/.cbuild_compile_commands/compile_commands.json; then
    json_path="${__SRC_DIR}/.cbuild_compile_commands/compile_commands.json"
    return 0
  fi

  for DIR in ${BUILD_DIR} ${__SRC_DIR}/build ${__SRC_DIR}; do
    if [[ "$json_path" != "" ]]; then
      break
    fi

    json_path=$(find ${DIR} -name "compile_commands.json" || true)
    if [[ "$json_path" != "" ]]; then
      break
    fi

    ninja_build_path=$(find ${DIR} -name "build.ninja" || true)
    if [[ "$ninja_build_path" != "" ]]; then
      cd $(dirname $ninja_build_path)
      ninja -t compdb >compile_commands.json
      json_path=$(find $(pwd) -name "compile_commands.json" || true)
      if [[ "$json_path" != "" ]]; then
        break
      fi
    fi
  done
  jq -s 'add | unique_by(.file)' $json_path >${__SRC_DIR}/.cbuild_compile_commands/compile_commands.json
  json_path="${__SRC_DIR}/.cbuild_compile_commands/compile_commands.json"
  return 0
}

if test -f ${INSTALL_PREFIX}/llvm_tool/run-clang-tidy.py; then
  run_clang_tidy_cmd="${CBUILD_PYTHON_EXE} ${INSTALL_PREFIX}/llvm_tool/run-clang-tidy.py -excluded-file-patterns '(.*/third_party/.*)|(.*cu$)' -j ${MAX_JOBS} "
  if test -f ${__SRC_DIR}/.clang-tidy; then
    run_clang_tidy_cmd="${run_clang_tidy_cmd} -config-file=${__SRC_DIR}/.clang-tidy "
  else
    run_clang_tidy_cmd="${run_clang_tidy_cmd} -config-file=${INSTALL_PREFIX}/cli_tool_configs/cpp-clang-tidy  "
  fi
else
  run_clang_tidy_cmd=""
fi

if [[ "${run_clang_tidy_cmd}" != "" ]]; then
  if [[ "${clang_tidy_fix:-}" == "1" ]]; then
    get_json_path
    if [[ "$json_path" != "" ]]; then
      echo "run clang_tidy_fix"
      mkdir -p "${STATIC_ANALYSIS_DIR}"
      eval "${run_clang_tidy_cmd} -j $MAX_JOBS -p $(dirname $json_path) -fix -quiet >${STATIC_ANALYSIS_DIR}/run-clang-tidy.txt"
      echo "end run clang_tidy_fix"
      export clang_tidy_static_analysis="0"
    else
      echo "no compile_commands.json to run clang_tidy_fix"
    fi
  fi
fi
