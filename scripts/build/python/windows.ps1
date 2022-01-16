cd $__SRC_DIR

if ((Test-Path requirements.txt -PathType Leaf)) {
  sed_cmd -i -e '/git:/d' requirements.txt
  Invoke-Expression "$env:CBUILD_PYTHON_EXE install -r requirements.txt --user"
}


if ((Test-Path setup.py -PathType Leaf)) {
  if ($env:reuse_build -ne "1") {
    if ((Test-Path build -PathType Container)) {
      rm -r -Force build
    }
    if ((Test-Path dist -PathType Container)) {
      rm -r -Force dist
    }
  }

  if ((Test-Path env:PYTHON_BUILD_CMD)) {
    Invoke-Expression "$env:PYTHON_BUILD_CMD"
  } else {
    Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py build_ext --inplace"
  }

  if ($LastExitCode -ne 0) {
    exit $LastExitCode
  }
  Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py install --user --force"
  if ($LastExitCode -ne 0) {
    exit $LastExitCode
  }
}
