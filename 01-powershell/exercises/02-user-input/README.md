# Project 02 — User Input Script

## Objective
Practice reading input from a user, validating it, and branching
logic based on that input — the foundation of interactive
administration scripts.

## What it does
Prompts for a username and an action (`enable`, `disable`, `info`),
validates the input, and simulates the corresponding action. Includes
a confirmation prompt before the "disable" action, mirroring
safe-by-default identity administration patterns.

## Run it
​```powershell
pwsh ./user-input.ps1
​```

## Concepts demonstrated
- `Read-Host`
- Input validation (`[string]::IsNullOrWhiteSpace`)
- `switch` statements
- Confirmation prompts before destructive actions
- `exit`