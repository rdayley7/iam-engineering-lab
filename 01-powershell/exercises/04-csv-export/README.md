# Project 04 — CSV Export

## Objective
Take user records, shape each one into a structured object, and write
the results back out to a CSV — the pattern behind bulk-provisioning
files, onboarding sheets, and access reports.

## What it does
Imports `users.csv`, builds a provisioning record for each user
(display name, a derived username, UPN, department, title, and account
status) as a PowerShell object, previews the work in the console, and
exports the finished records to `provisioned-users.csv` using
`Export-Csv`.

## Run it
```powershell
pwsh ./csv-export.ps1
```

Point it at different input/output files or a different domain:
```powershell
pwsh ./csv-export.ps1 -Path "/path/to/users.csv" -OutputPath "/path/to/provisioned.csv" -Domain "yourcompany.com"
```

## Concepts demonstrated
- The `Import-Csv` → transform → `Export-Csv` round trip
- `[PSCustomObject]` for building structured records
- Derived / calculated properties (`SamAccountName`, `UserPrincipalName`)
- Capturing `foreach` output into a variable (the pipeline)
- `Export-Csv -NoTypeInformation`
- `Write-Host` (console only) vs. pipeline output (the captured objects)
- `param()` defaults and `$PSScriptRoot` relative paths

## Note on the output
The `Write-Host` "Preparing…" lines print to the console but are **not**
written to the CSV. Only the `[PSCustomObject]` emitted each loop
iteration flows down the pipeline into `$provisioned`, which is what
`Export-Csv` writes. This separation between the console (host) stream
and the pipeline (output) stream is a core PowerShell concept.