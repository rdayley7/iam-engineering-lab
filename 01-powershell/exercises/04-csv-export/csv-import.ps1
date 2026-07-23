<#
.SYNOPSIS
    Imports users, builds provisioning records, and exports them to a CSV.
.DESCRIPTION
    Fourth project in the IAM Engineering Lab. Builds on Project 03 by
    taking imported user data, shaping each record into a structured
    object (with a derived username, UPN, and account status), and
    writing the results back out to a CSV with Export-Csv — the same
    pattern used to produce onboarding sheets, bulk-provisioning files,
    and access reports.
#>

param(
    [string]$Path       = "$PSScriptRoot/users.csv",
    [string]$OutputPath = "$PSScriptRoot/provisioned-users.csv",
    [string]$Domain     = "contoso.com"
)

if (-not (Test-Path $Path)) {
    Write-Host "CSV file not found at $Path" -ForegroundColor Red
    exit
}

$users = Import-Csv -Path $Path

Write-Host "Loaded $($users.Count) users from $Path" -ForegroundColor Cyan
Write-Host ""

# Capture the loop's output into $provisioned. Each iteration EMITS one
# [PSCustomObject] (which flows down the pipeline and is collected),
# while Write-Host writes to the console only and is NOT captured.
$provisioned = foreach ($user in $users) {
    $username = "$($user.FirstName.Substring(0,1))$($user.LastName)".ToLower()

    Write-Host "Preparing $($user.FirstName) $($user.LastName) -> $username"

    [PSCustomObject]@{
        DisplayName       = "$($user.FirstName) $($user.LastName)"
        SamAccountName    = $username
        UserPrincipalName = "$username@$Domain"
        Department        = $user.Department
        Title             = $user.Title
        AccountEnabled    = $true
    }
}

$provisioned | Export-Csv -Path $OutputPath -NoTypeInformation

Write-Host ""
Write-Host "Exported $($provisioned.Count) records to $OutputPath" -ForegroundColor Green