#
# if ($env:static_analysis -eq "1") {
#     $sln_path = (Get-ChildItem -Path $env:BUILD_DIR  -Filter *.sln -Recurse -ErrorAction SilentlyContinue -Force)
#     if ($LastExitCode -eq 0) {
#         if (Get-Command PVS-Studio_Cmd) {
#             PVS-Studio_Cmd --target $sln_path --progress -o ./pvs-studio.plog
#             PlogConverter -t Txt -o $env:STATIC_ANALYSIS_DIR ./pvs-studio.plog
#         }
#     }
#     $json_path = (Get-ChildItem -Path $env:BUILD_DIR  -Filter compile_commands.json -Recurse -ErrorAction SilentlyContinue -Force)
#     if ($LastExitCode -eq 0) {
#         Get-Command cppcheck -ErrorAction SilentlyContinue
#         if ($LastExitCode -eq 0) {
#             cppcheck --project=$json_path -j $env:MAX_JOBS --std=c++20 --enable=all --inconclusive 2>./do_cppcheck.txt
#             cp ./do_cppcheck.txt $env:STATIC_ANALYSIS_DIR
#         }
#     }
# }

if ($env:FEATURE_feature_language_python -eq "1") {
    if ((Test-Path  $env:INSTALL_PREFIX/bin )) {
        cd $env:INSTALL_PREFIX/bin
        $py_dir = (Split-Path -Path  ((Get-Command python).source))
        cp -ErrorAction 'silentlycontinue' *dll ${py_dir} 
    }
}
