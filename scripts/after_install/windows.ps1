if ($env:static_analysis -eq "1") {
    $json_path = (Get-ChildItem -Path $env:BUILD_DIR  -Filter *.sln -Recurse -ErrorAction SilentlyContinue -Force)
    if ($LastExitCode -eq 0) {
        cd (dirname $json_path)
        if (Get-Command PVS-Studio_Cmd) {
            PVS-Studio_Cmd --incremental ScanAndAnalyze --target *.sln --progress -o ./pvs-studio.log
            PlogConverter -t "FullHtml,Tasks" -o . -n pvs-studio-report ./pvs-studio.log
            cp ./pvs-studio-report $env:STATIC_ANALYSIS_DIR
        }
        if (Get-Command cppcheck) {
            cppcheck --project=./compile_commands.json -j $env:MAX_JOBS --std=c++20 --enable=all --inconclusive 2>./do_cppcheck.txt
            cp ./do_cppcheck.txt $env:STATIC_ANALYSIS_DIR
        }
    }
}
