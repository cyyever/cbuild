cd $__SRC_DIR

if ((Test-Path requirements.txt -PathType Leaf)) {
    sed -i -e '/cyyever/d' requirements.txt
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip install -r requirements.txt --user"
}

if ($env:reuse_build -ne "1") {
    if ((Test-Path build -PathType Container)) {
        rm -r -Force build
    }
    if ((Test-Path dist -PathType Container)) {
        rm -r -Force dist
    }
}

if ($env:use_setup_py -eq "1") {
    rm pyproject.toml
}

if ((Test-Path pyproject.toml -PathType Leaf)) {
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip install --no-build-isolation . --user --force"
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
}
elseif ((Test-Path setup.py -PathType Leaf)) {
    if ((Test-Path env:PYTHON_BUILD_CMD)) {
        Invoke-Expression "$env:PYTHON_BUILD_CMD"
    }
    else {
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
if ($env:run_test -eq "1" ) {
    if ((Test-Path env:TEST_SUBDIR)) {
        cd $env:TEST_SUBDIR
    }
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pytest"
}
