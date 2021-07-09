foreach ($pkg in $env:chocolatey_pkgs.Split(" ")) {
    chocolatey.exe search  -l -e "$pkg" | Out-Null
    if ($lastExitCode -ne "0") {
        Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "install -y $pkg"
    }
    else {
        Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "upgrade -y $pkg"
    }
}
