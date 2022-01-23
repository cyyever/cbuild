$new_path = ""
[System.Collections.ArrayList]$path_list = $env:path.split(";")
foreach ( $my_path  in ($path_list | select-object -Unique    )  ) {
  if($my_path.Contains('mingw')) {
        continue
    }
    $new_path += ";$my_path"
}
$env:path=$new_path
