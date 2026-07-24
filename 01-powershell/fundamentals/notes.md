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

## Hashtables
A hashtable stores key/value pairs — like a small lookup table.
Written with `@{ }`. In Project 04, a hashtable literal is the
shape handed to `[PSCustomObject]` to build each provisioning
record.
```powershell
$user = @{
    FirstName = "Ryan"
    LastName  = "Dayley"
}
$user["FirstName"]   # look up a value by key -> Ryan
$user.LastName       # dot notation works too  -> Dayley
```

## Objects
Almost everything in PowerShell is an object: a bundle of properties
(data) and methods (actions). `[PSCustomObject]` turns a hashtable
of properties into your own object — the clean way to assemble a
record before exporting it. Used in Project 04 to shape each user
into a provisioning record.
```powershell
$record = [PSCustomObject]@{
    DisplayName    = "Ryan Dayley"
    SamAccountName = "rdayley"
    AccountEnabled = $true
}
$record.SamAccountName   # access a property -> rdayley
```

## Pipeline
The pipe `|` sends the objects coming out of one command straight
into the next, without temporary variables. It's what makes
`... | Export-Csv` and `... | Where-Object` work. Note that
`Write-Host` prints to the console only — it does NOT travel down
the pipeline; only emitted objects do (see Project 04).
```powershell
$provisioned | Export-Csv -Path $OutputPath -NoTypeInformation
$users | Where-Object { $_.Department -eq "IT" }   # $_ = current object
```