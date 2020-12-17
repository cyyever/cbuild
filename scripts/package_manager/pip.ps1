Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip install --upgrade --user pip"
foreach ($pkg in $env:pip_pkgs.Split(" ")) {
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip install --upgrade --user $pkg"
}
