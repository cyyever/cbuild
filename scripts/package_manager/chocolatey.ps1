foreach ($pkg in $env:chocolatey_pkgs.Split(" ")) {
    choco.exe search -e "$pkg" | Out-Null
    if ($lastExitCode -ne "0") {
        Start-Process -Wait -Verb runAs choco.exe -ArgumentList "install -y $pkg"
    }
    # else {
    #     Start-Process -Wait -Verb runAs chocolatey.exe -ArgumentList "upgrade -y $pkg"
    # }
}
