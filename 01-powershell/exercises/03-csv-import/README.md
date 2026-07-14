# Project 03 — CSV Import

## Objective
Read structured user data from a CSV and process each record —
the foundation for bulk provisioning, account audit, and reporting
scripts.

## What it does
Imports `users.csv`, loops through each row, generates a sample
username from first/last name, and prints a summary per user.

## Run it
​```powershell
pwsh ./csv-import.ps1
​```

Optionally point it at a different file:
​```powershell
pwsh ./csv-import.ps1 -Path "/path/to/other-users.csv"
​```

## Concepts demonstrated
- `Import-Csv`
- `foreach` loops
- Object property access (`$user.FirstName`)
- String manipulation / derived values
- `$PSScriptRoot` for relative file paths
- `Test-Path` for file existence checks