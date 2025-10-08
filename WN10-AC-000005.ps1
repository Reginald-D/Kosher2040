<#
.SYNOPSIS
Remediates STIG ID WN10-AC-000005 (Account Lockout Duration)

.DESCRIPTION
Configures the local security policy "Account lockout duration" to meet STIG compliance (≥15 minutes or 0).
#>

# Define desired lockout duration (minutes)
$DesiredDuration = 15   # Change to 0 if using admin-unlock policy

Write-Host "Checking current Account Lockout Duration..." -ForegroundColor Cyan
$currentDuration = (net accounts | Select-String "Lockout duration").ToString().Split(":")[1].Trim().Split(" ")[0]

Write-Host "Current Lockout Duration: $currentDuration minutes"

if ([int]$currentDuration -lt $DesiredDuration -and [int]$currentDuration -ne 0) {
    Write-Host "Updating Account Lockout Duration to $DesiredDuration minutes..." -ForegroundColor Yellow
    net accounts /lockoutduration:$DesiredDuration | Out-Null
    Start-Sleep -Seconds 2
    Write-Host "Lockout duration successfully updated." -ForegroundColor Green
} elseif ([int]$currentDuration -eq 0) {
    Write-Host "Lockout duration is set to 0 (administrator unlock). This is acceptable per STIG." -ForegroundColor Green
} else {
    Write-Host "Lockout duration already meets or exceeds STIG requirement." -ForegroundColor Green
}

# Verify the change
Write-Host "`nVerifying current settings..." -ForegroundColor Cyan
net accounts | Select-String "Lockout duration"
Write-Host "`nSTIG WN10-AC-000005 compliance check complete." -ForegroundColor Green
