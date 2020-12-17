# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

# Check to see if we are currently running as an administrator
if (! $myWindowsPrincipal.IsInRole($adminRole)) {
    # We are not running as an administrator, so relaunch as administrator
    # Create a new process object that starts PowerShell
    $newProcessInfo = New-Object System.Diagnostics.ProcessStartInfo  (Get-Process -Id $pid).Path 
    # Specify the current script path and name as a parameter with added scope and support for scripts with spaces in it's path
    $newProcessInfo.Arguments = "-NoProfile -File " + $script:MyInvocation.MyCommand.Path 
    # Indicate that the process should be elevated
    $newProcessInfo.Verb = "runas";
    $newProcessInfo.UseShellExecute = $True
    # Start the new process
    $newProcess = New-Object System.Diagnostics.Process
    $newProcess.StartInfo = $newProcessInfo
    $newProcess.Start();
    $newProcess.WaitForExit();
    # Exit from the current, unelevated, process
    Exit $newProcess.ExitCode
}

if (!(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online)) {
    cd ${env:SystemRoot}/servicing/Packages/
    $files = ls *Hyper-V*.mum
    foreach ($file in $files) {
        dism  /online /norestart /add-package:"${file}"
    }
}
dism /online /norestart /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
