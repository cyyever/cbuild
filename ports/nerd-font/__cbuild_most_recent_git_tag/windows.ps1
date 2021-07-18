cd $env:SRC_DIR

$fontFiles = New-Object 'System.Collections.Generic.List[System.IO.FileInfo]'
Get-ChildItem $env:SRC_DIR -Filter "*.ttf" -Recurse | Foreach-Object {$fontFiles.Add($_)}
Get-ChildItem $env:SRC_DIR -Filter "*.otf" -Recurse | Foreach-Object {$fontFiles.Add($_)}

$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$fonts = $null
foreach ($fontFile in $fontFiles) {
   $Destination.CopyHere($fontFile,0x10)
}
