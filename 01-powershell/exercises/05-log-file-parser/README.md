# Project 05 — Log File Parser

## Objective
Read a raw text log, pull structured fields out of each line with a
regular expression, then filter and group the results — the pattern
behind failed sign-in reports, brute-force detection, and Entra
sign-in log review.

## What it does
Reads `auth.log` line by line, uses a named-group regex to extract the
timestamp, result, user, and IP from each entry, keeps only the
`FAILURE` events, groups them by user, and prints a count per user
(most failures first). Any user at or over the `-Threshold` is flagged.

## Run it
```powershell
pwsh ./log-parser.ps1
```

Point it at a different log or change the alert threshold:
```powershell
pwsh ./log-parser.ps1 -Path "/path/to/auth.log" -Threshold 5
```

## Expected output (with the sample log)
```
Parsed 10 log entries from ./auth.log
Found 7 failed sign-ins

Failed sign-ins by user:
  jsmith     4  <-- at/over threshold (3)
  rdayley    2
  cbrooks    1
```

## Concepts demonstrated
- `Get-Content` to read a file line by line
- Regular expressions with `-match` and named groups (`$Matches`)
- Building objects from parsed text (`[PSCustomObject]`)
- `Where-Object` to filter the pipeline
- `Group-Object` and `Sort-Object` to summarize and rank
- The `-f` format operator for aligned console output
- A `-Threshold` parameter to make the alert level configurable