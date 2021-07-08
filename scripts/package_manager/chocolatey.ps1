foreach ($pkg in $env:chocolatey_pkgs.Split(" ")) {
  chocolatey.exe search  -l -e "$pkg" | Out-Null
    if ($lastExitCode -ne "0") {
      start-process -wait -verb runAs chocolatey.exe -argumentlist "install -y $pkg"
    } else {
      start-process -wait -verb runAs chocolatey.exe -argumentlist "upgrade -y $pkg"
    }
}
