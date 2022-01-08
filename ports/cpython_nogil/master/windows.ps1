cd $env:SRC_DIR
if ($env:INSTALL_SUBDIR) {
    $__INSTALL_PREFIX = "$env:INSTALL_PREFIX/$env:INSTALL_SUBDIR"
}
else {
    $__INSTALL_PREFIX = "$env:INSTALL_PREFIX"
}

if ((Test-Path -Path $__INSTALL_PREFIX) ) {
    rm -r $__INSTALL_PREFIX
}
mkdir -p $__INSTALL_PREFIX
cp -r * $__INSTALL_PREFIX

$env:Py_OutDir = $__INSTALL_PREFIX
.\PCBuild\build.bat  -c $env:BUILD_TYPE -p x64
if ($LastExitCode -ne 0) {
    exit $LastExitCode
}


curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
if ($LastExitCode -ne 0) {
    exit $LastExitCode
}
Invoke-Expression "${__INSTALL_PREFIX}/amd64/python.exe get-pip.py"
if ($LastExitCode -ne 0) {
    exit $LastExitCode
}
