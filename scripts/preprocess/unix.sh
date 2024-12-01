sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

sed_cmd=sed
if command -v gsed >/dev/null; then
  sed_cmd=gsed
fi

if [[ -z ${make_cmd+x} ]]; then
  make_cmd=make
fi
# if command -v gmake >/dev/null; then
#   make_cmd=gmake
# fi

if [[ "${BUILD_CONTEXT_docker:=0}" == 0 ]]; then
  if [[ -n ${CUDA_HOME+x} ]]; then
    export CUDAToolkit_ROOT="${CUDA_HOME}"
  fi
  if [[ -n ${CUDA_TOOLKIT_ROOT+x} ]]; then
    export CUDAToolkit_ROOT="${CUDA_TOOLKIT_ROOT}"
  fi

  if [[ -n ${CUDAToolkit_ROOT=+x} ]]; then
    export CUDACXX="${CUDAToolkit_ROOT}/bin/nvcc"
    if test -f ${CUDAToolkit_ROOT}/extras/demo_suite/deviceQuery; then
      if ${CUDAToolkit_ROOT}/extras/demo_suite/deviceQuery >/dev/null; then
        cudaarchs=$(${CUDAToolkit_ROOT}/extras/demo_suite/deviceQuery | grep Capability | grep -E '[0-9.]*' -o | uniq | ${sed_cmd} -e 's/\.//')
        if [[ "$cudaarchs" != "$CUDAARCHS" ]]; then
          echo "change CUDAARCHS from ${CUDAARCHS} to ${cudaarchs}"
          export CUDAARCHS="$cudaarchs"
        fi
      else
        echo "can't deviceQuery"
      fi
    fi
  fi
else
  export CUDAARCHS="all-major"
  ${sudo_cmd} chown $(whoami) -R ${SRC_DIR} || true
  mkdir -p ${BUILD_DIR} || true
  ${sudo_cmd} chown $(whoami) -R ${BUILD_DIR} || true
fi
if [[ "${CUDAARCHS}" == "80" ]]; then
  export TORCH_CUDA_ARCH_LIST="8.0"
fi
if [[ "${CUDAARCHS}" == "86" ]]; then
  export TORCH_CUDA_ARCH_LIST="8.6"
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

if ! command -v ${CBUILD_PYTHON_EXE} &>/dev/null; then
  CBUILD_PYTHON_EXE=python3
fi

if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
  CBUILD_PYTHON_EXE="${sudo_cmd} env LD_LIBRARY_PATH=${INSTALL_PREFIX}/python/lib ${CBUILD_PYTHON_EXE}"
fi

CBUILD_PIP_EXE="${CBUILD_PYTHON_EXE} -m pip"

if [[ "${static_analysis}" == "1" ]] || [[ "${clang_tidy_fix:=0}" == "1" ]]; then
  export need_compilation_json=1
fi

json_path=""

get_json_path() {
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
    if ! test -d $DIR; then
      continue
    fi
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
  if [[ "$json_path" != "" ]]; then
    jq -s 'add | unique_by(.file)' $json_path >${__SRC_DIR}/.cbuild_compile_commands/compile_commands.json
    json_path="${__SRC_DIR}/.cbuild_compile_commands/compile_commands.json"
  fi
  return 0
}

get_run_clang_tidy_cmd() {
  if [[ -n ${run_clang_tidy_cmd+x} ]]; then
    return 0
  fi
  run_clang_tidy_cmd=""
  if test -f ${INSTALL_PREFIX}/llvm_tool/run-clang-tidy.py; then
    if [[ -z ${__SRC_DIR+x} ]]; then
      return 0
    fi
    run_clang_tidy_cmd="${CBUILD_PYTHON_EXE} ${INSTALL_PREFIX}/llvm_tool/run-clang-tidy.py -excluded-file-patterns '(.*/third_party/.*)|(.*[.]pb[.])|(.*/test/.*)|(.*/build/.*)' -j ${MAX_JOBS} -format-style=file -timeout=7200"
    if [[ -n ${1+x} ]]; then
      config_file="$1"
      if test -f $config_file; then
        echo "use clang-tidy config file $config_file"
        run_clang_tidy_cmd="${run_clang_tidy_cmd} -config-file=${config_file} "
        return 0
      fi
    fi
    for config_file in ${INSTALL_PREFIX}/cli_tool_configs/cpp-clang-tidy ${__SRC_DIR}/.__cbuild_clang-tidy ${__SRC_DIR}/.clang-tidy; do
      if test -f $config_file; then
        echo "use clang-tidy config file $config_file"
        run_clang_tidy_cmd="${run_clang_tidy_cmd} -config-file=${config_file} "
        return 0
      fi
    done
  fi
}

if command -v ccache >/dev/null; then
  export CCACHE_CPP2="true"
  if [[ -n ${__SRC_DIR+x} ]]; then
    export CCACHE_BASEDIR="${__SRC_DIR}"
  fi
  export CCACHE_SLOPPINESS="pch_defines,time_macros"
  for lang in C CXX CUDA; do
    eval "export CMAKE_${lang}_COMPILER_LAUNCHER=ccache"
  done
fi

if [[ -n ${FEATURE_feature_language_python+x} ]]; then
  if [[ -z ${py_pkg_name+x} ]]; then
    py_pkg_name=${PACKAGE_NAME}
  fi
fi

if [[ -n ${uninstalled_pip_pkgs+x} ]]; then
  cd /tmp
  for py_pkg_name in $uninstalled_pip_pkgs; do
    for _ in $(seq 3); do
      ${CBUILD_PIP_EXE} uninstall $py_pkg_name -y || true
    done
  done
fi

run_clang_tidy_fix() {
  if [[ "${clang_tidy_fix:-}" != "1" ]]; then
    return 1
  fi
  get_run_clang_tidy_cmd ${INSTALL_PREFIX}/cli_tool_configs/cpp-clang-tidy-fix-cbuild
  if [[ "${run_clang_tidy_cmd}" == "" ]]; then
    echo "no clang-tidy to fix code"
    return 1
  fi
  get_json_path
  if [[ "$json_path" == "" ]]; then
    echo "no compile_commands.json to run clang-tidy fix"
    return 1
  fi
  cd $__SRC_DIR
  mkdir -p "${STATIC_ANALYSIS_DIR}"
  eval "${run_clang_tidy_cmd} -j $MAX_JOBS -p $(dirname $json_path) -fix -quiet >${STATIC_ANALYSIS_DIR}/run-clang-tidy.txt"
  return
}
