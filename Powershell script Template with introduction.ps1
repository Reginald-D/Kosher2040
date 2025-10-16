<#
.SYNOPSIS
    This PowerShell script ensures that Group Policy is configured to reprocess even if the Group Policy objects have not changed, 
    meeting DISA STIG compliance for WN11-CC-000090.

.NOTES
    Author          : [Your Name]
    LinkedIn        : [Your LinkedIn URL]
    GitHub          : [Your GitHub URL]
    Date Created    : 2024-10-06
    Last Modified   : 2024-10-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000090

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : Windows 10 / Windows 11
    PowerShell Ver. : 5.1 / 7.x

.USAGE
    Example:
    PS C:\> .\Remediate_WN11-CC-000090.ps1
#>

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Applying STIG Fix: Configure registry policy processing to reprocess even if GPOs have not changed..." -ForegroundColor Cyan

# Define registry path and settings
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$valueName = "NoGPOListChanges"
$desiredValue = 0

# Create registry path if missing
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Apply STIG configuration
New-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -PropertyType DWORD -Force | Out-Null

# Verify change
$currentValue = (Get-ItemProperty -Path $regPath -Name $valueName).$valueName
if ($currentValue -eq $desiredValue) {
    Write-Host "Registry policy processing successfully configured to reprocess even if GPOs have not changed." -ForegroundColor Green
} else {
    Write-Host "Failed to configure policy setting. Current value: $currentValue" -ForegroundColor Red
}

Write-Host "Remediation complete for STIG ID WN11-CC-000090." -ForegroundColor Cyan
