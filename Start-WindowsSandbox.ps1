#cSpell:disable

param (
    [string] $MappedFolder = "G:\projects\windows-sandbox",
    [string] $LogonCommand = "Install-WinGet-and-Packages.ps1"
)

# Check if Windows Sandbox is already running. 
if (Get-Process -Name 'WindowsSandbox' -ErrorAction SilentlyContinue) {
    Write-Warning "Windows Sandbox is running. Exiting..."
    Return 
}

# Validate if $MappedFolder exists
if ($MappedFolder) {
    if (Test-Path -PathType Container -Path "$MappedFolder") {
        Write-Host "Specified $MappedFolder exists, continuing..." -ForegroundColor Green
    }
    else {
        Write-Warning "Specified $MappedFolder does not exist, exiting..."
        Return 
    }
}

if (-not (Test-Path "$($MappedFolder)\$($LogonCommand)")) {
    Write-Warning "Specified LogonCommand $LogonCommand does not exist in $MappedFolder. Exiting..."
    Return 
}

$wsbFile = "$($MappedFolder)\WindowsSandbox.wsb"
$LogonCommandFull = 'Powershell.exe -ExecutionPolicy bypass -File C:\users\wdagutilityaccount\desktop\' + $(Get-ChildItem -Path $($wsbFile) -Directory).Directory.Name + '\' + $LogonCommand
Tee-Object -FilePath $wsbFile -Append:$false

$wsb = @()
$wsb += "<Configuration>"
$wsb += "<MappedFolders>"
$wsb += "<MappedFolder>"
$wsb += "<HostFolder>$($MappedFolder)</HostFolder>"
$wsb += "<ReadOnly>true</ReadOnly>"
$wsb += "</MappedFolder>"
$wsb += "</MappedFolders>"
$wsb += "<LogonCommand>"
$wsb += "<Command>$($LogonCommandFull)</Command>"
$wsb += "</LogonCommand>"
$wsb += "</Configuration>"

$wsb | Out-File $wsbFile -Force

Write-Host "Saved configuration in $wsbFile." -ForegroundColor Green
Write-Host "Starting Windows Sandbox..." -ForegroundColor Blue
Invoke-Item $wsbFile

Write-Host "All Done!" -ForegroundColor Green