for _ in $(seq 5); do
  ${CBUILD_PIP_EXE} uninstall cugraph -y || true
done
cd ${SRC_DIR}/python
rm -rf *.egg-info
rm -rf build
${CBUILD_PYTHON_EXE} setup.py build_ext --inplace
${CBUILD_PYTHON_EXE} setup.py install --user --force
