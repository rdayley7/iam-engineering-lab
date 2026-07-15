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

## Arrays
A collection of items stored in a single variable, accessed by
index (starting at 0). `Import-Csv` returns an array of objects —
one object per row. Each object's properties are accessed with
dot notation.
​```powershell
$users = Import-Csv -Path $Path
$users.Count        # number of rows/items in the array
$users[0]            # first user object
$users[0].FirstName  # a specific property on that object
​```

## Loops
`foreach` iterates over every item in an array or collection,
running the same block of code once per item. This is the core
pattern for processing a batch of records — bulk provisioning,
account audits, report generation, etc.
​```powershell
foreach ($user in $users) {
    Write-Host "$($user.FirstName) $($user.LastName)"
}
​```