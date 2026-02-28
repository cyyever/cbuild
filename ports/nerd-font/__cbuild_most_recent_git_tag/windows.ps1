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
    $fonts.CopyHere($fontFile.FullName, 0x14)
}
