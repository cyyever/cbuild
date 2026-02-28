cd $env:SRC_DIR


$fontFiles = [Collections.Generic.List[System.IO.FileInfo]]::new()

Get-ChildItem . -Filter "*.ttf" -Recurse | ForEach-Object { $fontFiles.Add($_) }
Get-ChildItem . -Filter "*.otf" -Recurse | ForEach-Object { $fontFiles.Add($_) }

$fonts = $null
foreach ($fontFile in $fontFiles) {
    if (!$fonts) {
        $shellApp = New-Object -ComObject shell.application
        $fonts = $shellApp.NameSpace(0x14)
    }
    $FOF_SILENT = 0x04
    $FOF_NOCONFIRMATION = 0x10
    $fonts.CopyHere($fontFile.FullName, $FOF_SILENT -bor $FOF_NOCONFIRMATION)
}
