cd $env:SRC_DIR
Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py build_ext --inplace"
if ($LastExitCode -ne 0) {
  exit $LastExitCode
}
Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py install --user --force"
if ($LastExitCode -ne 0) {
  exit $LastExitCode
}
