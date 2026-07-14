<#
.SYNOPSIS
    Basic PowerShell fundamentals: variables, parameters, and output formatting.
.DESCRIPTION
    First project in the IAM Engineering Lab. Demonstrates parameterized
    scripts, string interpolation, and basic conditional logic — the
    building blocks used later for identity/reporting automation.
#>

param(
    [string]$Name = "IAM Engineer"
)

$today = Get-Date -Format "yyyy-MM-dd"

Write-Host "Hello, $Name!" -ForegroundColor Cyan
Write-Host "Today's date is $today"

if ($Name -eq "IAM Engineer") {
    Write-Host "Tip: run this with -Name 'YourName' to pass a parameter." -ForegroundColor Yellow
}