cd ${BUILD_DIR}
# ${sed_cmd} -e "s/python_requires='>=3.6, <=3.9'/python_requires='>=3.6'/" -i dali/python/setup.py
${CBUILD_PIP_EXE} install dali/python --user
# cp ${SRC_DIR}/include/dali/util/half.hpp ${INSTALL_PREFIX}/include/dali/util
# cp ${SRC_DIR}/include/dali/core/common.h ${INSTALL_PREFIX}/include/dali/core
# if [[ "$run_test" == "1" ]]; then
#   export DALI_EXTRA_PATH="${__SRC_DIR}/../DALI_extra"
#   cmake --build . --target check-gtest
# fi
#   # cmake --build . --target check-python || true
