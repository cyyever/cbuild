if ($env:run_test -eq "1") {
    cd $home
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -c 'import numpy; numpy.test();'"
    $env:run_test = "0"
}
