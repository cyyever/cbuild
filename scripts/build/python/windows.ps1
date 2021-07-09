if (! (Test-Path env:py_pkg_name)) {
    $env:py_pkg_name = $env:PACKAGE_NAME
}

1..5 | foreach {
    Invoke-Expression "$CBUILD_PIP_EXE uninstall -y $env:py_pkg_name"
}

if ($env:SRC_SUBDIR) {
    $__SRC_DIR = "$env:SRC_DIR/$env:SRC_SUBDIR"
}
else {
    $__SRC_DIR = $env:SRC_DIR
}

cd $__SRC_DIR
if ((Test-Path setup.py -PathType Leaf)) {
    if ((Test-Path build -PathType Container)) {
        rm -r -Force build
    }

    Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py build_ext --inplace"
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
    Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py install --user --force"
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
    if ($env:run_test -eq "1") {
        if ((Test-Path build -PathType Container)) {
            rm -r -Force build
        }
        Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pytest"
        if ($env:PACKAGE_VERSION -ne "master") {
            if ($LastExitCode -ne 0) {
                exit $LastExitCode
            }
        }
    }
}
