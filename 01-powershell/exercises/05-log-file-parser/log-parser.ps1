<#
.SYNOPSIS
    Parses an authentication log and reports failed sign-ins per user.
.DESCRIPTION
    Fifth project in the IAM Engineering Lab. Reads a raw text auth log,
    extracts structured fields from each line with a regular expression,
    then filters and groups the results to surface users with repeated
    failed sign-ins — the same analysis behind brute-force detection and
    Entra sign-in log review.
#>

param(
    [string]$Path      = "$PSScriptRoot/auth.log",
    [int]   $Threshold = 3
)

if (-not (Test-Path $Path)) {
    Write-Host "Log file not found at $Path" -ForegroundColor Red
    exit
}

# Named-group regex pulls the fields out of each line, e.g.:
# 2026-07-20 08:15:11 FAILURE user=jsmith ip=203.0.113.9
$pattern = '^(?<Timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\s+(?<Result>\w+)\s+user=(?<User>\S+)\s+ip=(?<IP>\S+)'

# Read the file line by line and emit one object per matching line.
$events = foreach ($line in Get-Content -Path $Path) {
    if ($line -match $pattern) {
        [PSCustomObject]@{
            Timestamp = $Matches.Timestamp
            Result    = $Matches.Result
            User      = $Matches.User
            IP        = $Matches.IP
        }
    }
}

Write-Host "Parsed $($events.Count) log entries from $Path" -ForegroundColor Cyan

# Keep only the failed sign-ins.
$failures = $events | Where-Object { $_.Result -eq "FAILURE" }

Write-Host "Found $($failures.Count) failed sign-ins" -ForegroundColor Yellow
Write-Host ""

# Group the failures by user and count them, most failures first.
$byUser = $failures |
    Group-Object -Property User |
    Sort-Object -Property Count -Descending

Write-Host "Failed sign-ins by user:"
foreach ($group in $byUser) {
    $flag = if ($group.Count -ge $Threshold) { "  <-- at/over threshold ($Threshold)" } else { "" }
    Write-Host ("  {0,-10} {1}{2}" -f $group.Name, $group.Count, $flag)
}