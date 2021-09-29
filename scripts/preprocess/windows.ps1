$env:INSTALL_PREFIX = $env:INSTALL_PREFIX.Replace("\", "/")
$vs_path=(vswhere -latest -prerelease -property installationPath)
if ($vs_path) {
  cd $vs_path

    cd VC/Auxiliary/Build

    C:\Windows\System32\cmd.exe /c "call vcvarsall.bat x64 && set" | ForEach-Object {
      if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path "Env:$($matches[1])" -Value $matches[2]
      }
    }
}

Set-Alias -Name sed_cmd -Value sed
$CBUILD_PIP_EXE="$env:CBUILD_PYTHON_EXE -m pip"

if ((Test-Path env:SRC_SUBDIR)) {
    $__SRC_DIR = "$env:SRC_DIR/$env:SRC_SUBDIR"
}
else {
    $__SRC_DIR = $env:SRC_DIR
}

if ((Test-Path env:INSTALL_SUBDIR)) {
    $__INSTALL_PREFIX = "$env:INSTALL_PREFIX/$env:INSTALL_SUBDIR"
}
else {
    $__INSTALL_PREFIX = "$env:INSTALL_PREFIX"
}

if ((Test-Path env:FEATURE_feature_language_python)) {
  cd $Env:temp
    if (! (Test-Path env:py_pkg_name)) {
      $env:py_pkg_name = $env:PACKAGE_NAME
    }

  1..5 | foreach {
    Invoke-Expression "$CBUILD_PIP_EXE uninstall -y $env:py_pkg_name"
  }
}
