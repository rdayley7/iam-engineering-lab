<#
.SYNOPSIS
    Imports a CSV of users and processes each record.
.DESCRIPTION
    Third project in the IAM Engineering Lab. Demonstrates reading
    structured data from a CSV, looping through records, and building
    derived fields (like a username) — the same pattern used for
    bulk provisioning or account audit scripts.
#>

param(
    [string]$Path = "$PSScriptRoot/users.csv"
)

if (-not (Test-Path $Path)) {
    Write-Host "CSV file not found at $Path" -ForegroundColor Red
    exit
}

$users = Import-Csv -Path $Path

Write-Host "Loaded $($users.Count) users from $Path" -ForegroundColor Cyan
Write-Host ""

foreach ($user in $users) {
    $generatedUsername = "$($user.FirstName.Substring(0,1))$($user.LastName)".ToLower()

    Write-Host "Name:       $($user.FirstName) $($user.LastName)"
    Write-Host "Department: $($user.Department)"
    Write-Host "Title:      $($user.Title)"
    Write-Host "Username:   $generatedUsername"
    Write-Host "---"
}