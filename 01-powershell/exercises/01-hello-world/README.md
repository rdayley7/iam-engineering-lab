# Project 01 — Hello World

## Objective
Establish a working PowerShell 7 environment and demonstrate basic
scripting fundamentals: parameters, variables, string interpolation,
and conditional logic.

## What it does
Accepts an optional `-Name` parameter and prints a greeting with the
current date.

## Run it
​```powershell
pwsh ./hello-world.ps1
pwsh ./hello-world.ps1 -Name "Ryan"
​```

## Concepts demonstrated
- `param()` blocks
- Default parameter values
- String interpolation
- `Get-Date` formatting
- Conditional logic (`if`)