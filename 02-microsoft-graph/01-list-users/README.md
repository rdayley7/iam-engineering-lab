# Project 01 — List Users

## Objective
Make your first authenticated Microsoft Graph call from PowerShell: connect
to Entra ID and retrieve user accounts. Reading users is the read-only
foundation every reporting, audit, and cleanup script builds on.

## Prerequisites
Complete `../../SETUP.md` first — a free Entra tenant, PowerShell 7, and the
`Microsoft.Graph` module installed. This project uses the delegated scope
`User.Read.All`. The script connects automatically if you aren't already
connected; you can also connect ahead of time:
```powershell
Connect-MgGraph -Scopes "User.Read.All"
```

## What it does
Connects to Microsoft Graph (if needed), calls `Get-MgUser` for the
properties an admin cares about, optionally filters to disabled accounts,
sorts by display name, and prints a clean table.

## Run it
```powershell
pwsh ./list-users.ps1
```

Cap the result set, or show only disabled accounts:
```powershell
pwsh ./list-users.ps1 -Top 25
pwsh ./list-users.ps1 -DisabledOnly
```

## Expected output
```
Connected to tenant: 8f3a1c22-....-...-...-............
Retrieved 3 user(s)

DisplayName   UserPrincipalName                 Mail                        Enabled
-----------   -----------------                 ----                        -------
Alex Wilber   alexw@iamlabrdayley.onmicrosoft.com alexw@iamlab...           True
Megan Bowen   meganb@iamlabrdayley.onmicrosoft.com meganb@iamlab...         True
Test Disabled testd@iamlabrdayley.onmicrosoft.com                          False
```
(Your tenant ID, domain, and users will differ.)

## Concepts demonstrated
- `Connect-MgGraph` with a delegated **scope** (`User.Read.All`)
- `Get-MgContext` to detect an existing connection and read the tenant ID
- `Get-MgUser` with `-Property`, `-All`, and `-Top`
- Requesting non-default properties (`AccountEnabled`, `Mail`)
- `Where-Object` to filter, `Sort-Object` to order
- A calculated property (`@{ Name = ...; Expression = ... }`) to rename a field
- `try` / `catch` with `-ErrorAction Stop` around the connect and the query

## Notes / next
`Get-MgUser` maps to the REST call `GET /users` (see `../fundamentals/notes.md`).
Next project: **List Groups** (`Get-MgGroup`).
