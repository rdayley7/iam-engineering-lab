# PowerShell Fundamentals — Notes

## Variables
Variables in PowerShell are prefixed with `$` and are loosely typed
by default. Example:
​```powershell
$userName = "rdayley"
$today = Get-Date -Format "yyyy-MM-dd"
​```

## Operators
Comparison operators use letter-based syntax rather than symbols
(`-eq`, `-ne`, `-lt`, `-gt`) since symbols like `<` and `>` are
reserved for redirection.
​```powershell
if ($action.ToLower() -eq "y") { ... }
​```

## If / Else
Standard conditional branching. Used to validate input before
proceeding — e.g. rejecting empty input in Project 02.
​```powershell
if ([string]::IsNullOrWhiteSpace($userName)) {
    Write-Host "No username entered."
}
​```

## Switch
Cleaner than a long if/elseif chain when branching on one value
against several known options. Used in Project 02 to route the
`enable` / `disable` / `info` actions.
​```powershell
switch ($action.ToLower()) {
    "enable"  { ... }
    "disable" { ... }
    default   { ... }
}
​```