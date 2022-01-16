cd $__SRC_DIR
$env:cmake_build_dir=$env:BUILD_DIR
Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py install --user --force"
  if ($env:run_test -eq "1") {
    cd ${__SRC_DIR}/python_binding/test
	Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pytest"
  }
