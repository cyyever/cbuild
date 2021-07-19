cd $env:SRC_DIR
cd python
# rm -r protobuf.egg-info
# rm -r build

Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py build_ext --inplace"
Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py install --user --force"
