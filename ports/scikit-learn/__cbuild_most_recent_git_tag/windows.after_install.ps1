if ($env:test_numpy -eq "1") {
    cd $home
    Invoke-Expression "$env:CBUILD_PYTHON_EXE -c 'import numpy; numpy.test();'"
}
