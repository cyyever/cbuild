if ($env:INSTALL_SUBDIR) {
    $__INSTALL_PREFIX = "$env:INSTALL_PREFIX/$env:INSTALL_SUBDIR"
}
else {
    $__INSTALL_PREFIX = "$env:INSTALL_PREFIX"
}

if ($env:SRC_SUBDIR) {
    $__SRC_DIR = "$env:SRC_DIR/$env:SRC_SUBDIR"
}
else {
    $__SRC_DIR = $env:SRC_DIR
}
if ($env:try_cmake_again -ne "1") {
    $env:try_cmake_again = "0"
}


cd $env:BUILD_DIR

$install_prefix_exp = "-DCMAKE_INSTALL_PREFIX=$__INSTALL_PREFIX"

$test_exp = "-DBUILD_TESTING=OFF"
if ($env:run_test -eq "1") {
    $test_exp = "-DBUILD_TESTING=ON"
}

$cmake_cmd = "cmake -Wno-dev"

if ($env:CMAKE_GENERATOR -ne "native") {
    $cmake_cmd += " -G $env:CMAKE_GENERATOR"
}
else {
    $cmake_cmd += " -A x64"
    $env:CMAKE_GENERATOR = ""
}

$cmake_cmd += " -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_C_COMPILER=cl.exe -DCMAKE_BUILD_TYPE="
$cmake_cmd += $env:BUILD_TYPE
$cmake_cmd += " "
$cmake_cmd += $install_prefix_exp
$cmake_cmd += " "
$cmake_cmd += $test_exp
$cmake_cmd += " "
$cmake_cmd += $env:cmake_options
$cmake_cmd += " "
$cmake_cmd += $__SRC_DIR

Invoke-Expression $cmake_cmd
if ($LastExitCode -ne 0) {
    if ($env:try_cmake_again -eq "1") {
        Invoke-Expression $cmake_cmd
    }
}
if ($LastExitCode -ne 0) {
    exit $LastExitCode
}
cmake --build . --config $env:BUILD_TYPE
if ($LastExitCode -ne 0) {
    exit $LastExitCode
}
if (!$env:no_install -eq "1") {
    cmake --build . --config $env:BUILD_TYPE --target install
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
}

if ($env:run_test -eq "1") {
    if ($env:TEST_TARGET) {
        cmake --build . --config $env:BUILD_TYPE --target $env:TEST_TARGET
    }
    else {
        ctest -C $env:BUILD_TYPE
    }
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
}
