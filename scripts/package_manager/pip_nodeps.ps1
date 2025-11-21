Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade --user pip"
foreach ($pkg in $env:pip_nodeps_pkgs.Split(" ")) {
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade --user --no-deps $pkg"
}
