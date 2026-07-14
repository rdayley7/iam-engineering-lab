<#
.SYNOPSIS
    Demonstrates reading and validating user input in PowerShell.
.DESCRIPTION
    Second project in the IAM Engineering Lab. Prompts for a username
    and an action, validates the input, and branches based on the
    result. Mirrors the "confirm before you act" pattern used in
    identity administration scripts (e.g. disabling an account).
#>

$userName = Read-Host "Enter a username to look up"

if ([string]::IsNullOrWhiteSpace($userName)) {
    Write-Host "No username entered. Exiting." -ForegroundColor Red
    exit
}

Write-Host "You entered: $userName" -ForegroundColor Cyan

$action = Read-Host "What would you like to do? (enable / disable / info)"

switch ($action.ToLower()) {
    "enable" {
        Write-Host "Simulating: enabling account for $userName" -ForegroundColor Green
    }
    "disable" {
        $confirm = Read-Host "Are you sure you want to disable '$userName'? (y/n)"
        if ($confirm.ToLower() -eq "y") {
            Write-Host "Simulating: disabling account for $userName" -ForegroundColor Yellow
        } else {
            Write-Host "Disable cancelled." -ForegroundColor Gray
        }
    }
    "info" {
        Write-Host "Simulating: retrieving account info for $userName" -ForegroundColor Cyan
    }
    default {
        Write-Host "Unrecognized action: $action" -ForegroundColor Red
    }
}