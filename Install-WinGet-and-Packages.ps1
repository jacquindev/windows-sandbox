# cSpell:disable

$desktopPath = "C:\users\wdagutilityaccount\desktop"

Start-Transcript "$desktopPath\installing.txt"

# Install WinGet
# More information: https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget-on-windows-sandbox
$ProgressPreference = 'silentlyContinue'

Write-Host "Installing WinGet PowerShell module from PSGallery..." -ForegroundColor Cyan
Install-PackageProvider -Name NuGet -Force -Verbose
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..." -ForegroundColor Blue
Repair-WinGetPackageManager -Force -Verbose
Write-Host "Done." -ForegroundColor Green

# Packages to install by WinGet
$wingetPackages = "Git.Git", "Microsoft.VisualStudioCode", "Microsoft.WindowsTerminal", "Microsoft.PowerShell"

foreach ($package in $wingetPackages) {
    winget.exe install $package --silent --force --accept-package-agreements --accept-source-agreements --disable-interactivity -s winget
}

Stop-Transcript
Rename-Item -Path "$desktopPath\installing.txt" -NewName "$desktopPath\done.txt"