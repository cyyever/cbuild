if ($env:SRC_SUBDIR) {
    $__SRC_DIR = "$env:SRC_DIR/$env:SRC_SUBDIR"
}
else {
    $__SRC_DIR = $env:SRC_DIR
}

cd $__SRC_DIR
if ((Test-Path setup.py -PathType Leaf)) {
    if ((Test-Path build -PathType Container)) {
        rm -r -force build
    }

    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip uninstall ($env:CBUILD_PYTHON_EXE setup.py --name) -y"
    Invoke-Expression "$env:CBUILD_PYTHON_EXE setup.py install --user --force"
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
    if ($env:run_test -eq "1") {
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pytest"
        if ($env:PACKAGE_VERSION -ne "master") {
            if ($LastExitCode -ne 0) {
                exit $LastExitCode
            }
        }
    }
}
