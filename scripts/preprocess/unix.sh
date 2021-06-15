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

# if test -d "${INSTALL_PREFIX}/python"; then
#   export PYTHONHOME="${INSTALL_PREFIX}/python"
# fi

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
  for DIR in ${BUILD_DIR} ${__SRC_DIR}/build ${__SRC_DIR}; do
    if [[ "$json_path" != "" ]]; then
      return 0
    fi

    json_path=$(find ${DIR} -name "compile_commands.json" || true)
    if [[ "$json_path" != "" ]]; then
      return 0
    fi

    ninja_build_path=$(find ${DIR} -name "build.ninja" || true)
    if [[ "$ninja_build_path" != "" ]]; then
      cd $(dirname $ninja_build_path)
      ninja -t compdb >compile_commands.json
      json_path=$(find $(pwd) -name "compile_commands.json" || true)
      if [[ "$json_path" != "" ]]; then
        return 0
      fi
    fi
  done
  return 0
}

if test -f ${INSTALL_PREFIX}/llvm_tool/run-clang-tidy.py; then
  run_clang_tidy_cmd="${CBUILD_PYTHON_EXE} ${INSTALL_PREFIX}/llvm_tool/run-clang-tidy.py -excluded-file-patterns '(.*/third_party/.*)|(.*cu$)' -j ${MAX_JOBS} -config=\"$(cat ${INSTALL_PREFIX}/cli_tool_configs/cpp-clang-tidy)\" "
else
  run_clang_tidy_cmd=""
fi

if [[ "${run_clang_tidy_cmd}" != "" ]]; then
  if [[ "${clang_tidy_fix:-}" == "1" ]]; then
    get_json_path
    if [[ "$json_path" != "" ]]; then
      echo "run clang_tidy_fix"
      eval "${run_clang_tidy_cmd} -p $(dirname $json_path) -fix -quiet >/dev/null"
      echo "end run clang_tidy_fix"
    fi
  fi
fi
