build_by_cmake() {
  cd ${BUILD_DIR}
  cmake_generator_exp=''
  if [[ "${CMAKE_GENERATOR}" != "native" ]]; then
    cmake_generator_exp="-G ${CMAKE_GENERATOR}"
  else
    unset CMAKE_GENERATOR
  fi
  install_prefix_exp=''
  if [[ -z ${DEFAULT_INSTALL_PREFIX+x} ]]; then
    install_prefix_exp="-DCMAKE_INSTALL_PREFIX=${__INSTALL_PREFIX}"
  fi
  if [[ "${run_test}" == 1 ]]; then
    test_exp="-DBUILD_TESTING=ON"
  else
    test_exp="-DBUILD_TESTING=OFF"
  fi

  cmake -Wno-dev ${cmake_generator_exp} ${install_prefix_exp} ${test_exp} ${cmake_options} ${__SRC_DIR}
  CWD=$(pwd)
  run_clang_tidy_fix || true
  cd ${CWD}

  cmake_build_cmd='cmake --build .'
  if [[ -z ${no_install+x} ]]; then
    cmake_build_cmd="$cmake_build_cmd --target install"
    if [[ -n ${DEFAULT_INSTALL_PREFIX+x} ]]; then
      cmake_build_cmd="${sudo_cmd} $cmake_build_cmd"
    fi
  fi

  ${cmake_build_cmd}

  if [[ "${run_test}" == "1" ]]; then
    test_cmd=""
    if [[ -z ${TEST_TARGET+x} ]]; then
      test_cmd="ctest -C ${BUILD_TYPE}"
    else
      test_cmd="cmake --build . --target ${TEST_TARGET}"
    fi
    if [[ "${PACKAGE_VERSION}" == "master" ]]; then
      ${test_cmd} || true
    else
      ${test_cmd}
    fi
  fi
}
build_by_autotools() {
  cd ${__SRC_DIR}
  if test -f "${__SRC_DIR}/autogen.sh"; then
    bash autogen.sh
  elif test -f "${__SRC_DIR}/configure.ac"; then
    if [[ -z ${no_reconf+x} ]]; then
      autoreconf -i -f configure.ac
    fi
  fi
  if test -f "${__SRC_DIR}/configure"; then
    debug_option=""
    if [[ "${BUILD_TYPE}" == "Debug" ]]; then
      debug_option="--enable-debug=3"
    fi
    if [[ "${FEATURE_shared_lib+x}" == "1" ]]; then
      debug_option="--enable-shared"
    fi
    if [[ -n ${USE_BUILD_DIR+x} ]]; then
      cd ${BUILD_DIR}
    fi
    bash "${__SRC_DIR}/configure" --prefix="${__INSTALL_PREFIX}" ${debug_option} ${configure_options}
  fi
  if ! test -f "${__SRC_DIR}/Makefile" && ! test -f "${BUILD_DIR}/Makefile"; then
    echo "No Makefile"
    return 1
  fi
  if [[ "${reuse_build:=0}" == "0" ]]; then
    ${make_cmd} clean || true
  fi
  if [[ -n ${need_compilation_json+x} ]] && command -v bear; then
    bear -- ${make_cmd} -j $MAX_JOBS
    CWD=$(pwd)
    if run_clang_tidy_fix:; then
      bear -- ${make_cmd} -j $MAX_JOBS
      cd ${CWD}
    fi
  else
    ${make_cmd} -j $MAX_JOBS
  fi

  if [[ -z ${no_install+x} ]]; then
    env PREFIX="${__INSTALL_PREFIX}" ${make_cmd} install
  fi
  if [[ "${run_test}" == "1" ]]; then
    if [[ -n ${TEST_TARGET+x} ]]; then
      ${make_cmd} ${TEST_TARGET}
    else
      if ${make_cmd} -q test 2>/dev/null; then
        ${make_cmd} test
      fi
      if ${make_cmd} -q check 2>/dev/null; then
        ${make_cmd} check
      fi
    fi
  fi
}
build_package() {
  if [[ "${use_libtool:=0}" == "0" ]] && test -f "${__SRC_DIR}/CMakeLists.txt"; then
    build_by_cmake
  else
    build_by_autotools
  fi
}

build_package
