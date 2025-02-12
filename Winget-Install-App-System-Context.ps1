
# Install or upgrade software by using WinGet. Can be run in System context because
# the script tries to find the winget.exe from C:\Program Files\WindowsApps\ .



[cmdletbinding()]
param(
    [parameter(
        Mandatory         = $false,
        ValueFromPipeline = $true)]
    $pipelineInput,
    [string]$ID = "noID",
    [switch]$help
)

Process {

    # Print help 
    If ( "$ID" -eq "noID" -and $pipelineInput -eq $null) {
        Write-Host "Please give the Id of the package you want to install or upgrade by using Winget."
        Write-Host "        -id <Id>"
        Write-host " eg.    -id KDE.Okular"
        Write-host "App Id is also accepted from pipeline."
        exit 0
     }

    # Find path for winget.exe so winget can be run in system conntext.
    $WingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    If ($WingetPath){
            Write-Host "Found Winget $WingetPath"
       } Else {
           Write-Host "Did not found winget.exe from c:\Program Files\WindowsApps"
           Write-Host "Checking if Get-Command will find winget.exe"
           $WingetPath=(get-command winget.exe -EA ignore).source
           If ($WingetPath){
                Write-Host "Found Winget $WingetPath"
           } Else {
                Write-Host "Winget.exe not found!"
                exit 1
           }
    }


    If ( "$ID" -eq "noID" -and $pipelineInput -ne $null) {
        Write-Host "No parameter -id given but found input from pipeline."
        Write-Host "Pipeline input $pipelineInput"
        $ID = $pipelineInput
     }

    Write-Host "Trying to install or uprade $Id"
    & $WingetPath install $ID --accept-source-agreements --source winget


} # Process ends

