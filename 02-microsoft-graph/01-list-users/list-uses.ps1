<#
.SYNOPSIS
    Lists users from Microsoft Entra ID via the Microsoft Graph PowerShell SDK.
.DESCRIPTION
    First project in Phase 2 of the IAM Engineering Lab. Connects to Microsoft
    Graph, retrieves user accounts from Entra ID, and prints the properties an
    identity administrator actually cares about: display name, UPN, mail, and
    whether the account is enabled. This read-only query is the foundation that
    every reporting, audit, and cleanup script in this phase builds on.

    Requires the delegated scope User.Read.All. If the session isn't already
    connected, the script connects for you.
.PARAMETER Top
    Maximum number of users to return. Omit to return all users in the tenant.
.PARAMETER DisabledOnly
    Only display accounts that are disabled — a common first step in a
    stale-account or offboarding review.
.EXAMPLE
    pwsh ./list-users.ps1
.EXAMPLE
    pwsh ./list-users.ps1 -Top 25
.EXAMPLE
    pwsh ./list-users.ps1 -DisabledOnly
#>

[CmdletBinding()]
param(
    [int]    $Top,
    [switch] $DisabledOnly
)

# --- Ensure a Graph connection ---------------------------------------------
# Get-MgContext returns $null when the session isn't connected. We request the
# least-privileged scope that can read users: User.Read.All (read, not write).
$requiredScope = "User.Read.All"

if (-not (Get-MgContext)) {
    Write-Host "Not connected to Microsoft Graph. Connecting..." -ForegroundColor Yellow
    try {
        Connect-MgGraph -Scopes $requiredScope -NoWelcome -ErrorAction Stop
    }
    catch {
        Write-Host "Failed to connect to Microsoft Graph: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Connected to tenant: $((Get-MgContext).TenantId)" -ForegroundColor Cyan

# --- Retrieve users ---------------------------------------------------------
# Only ask for the properties we display. AccountEnabled and Mail aren't
# returned by default, so they must be named explicitly with -Property.
$properties = "DisplayName", "UserPrincipalName", "Mail", "AccountEnabled", "Id"

$getParams = @{ Property = $properties }
if ($PSBoundParameters.ContainsKey("Top")) {
    $getParams.Top = $Top          # cap the result set
} else {
    $getParams.All = $true         # page through the whole directory
}

try {
    $users = Get-MgUser @getParams -ErrorAction Stop
}
catch {
    Write-Host "Failed to retrieve users: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

if ($DisabledOnly) {
    $users = $users | Where-Object { -not $_.AccountEnabled }
}

# --- Output -----------------------------------------------------------------
Write-Host "Retrieved $($users.Count) user(s)" -ForegroundColor Green
Write-Host ""

$users |
    Sort-Object DisplayName |
    Select-Object DisplayName,
                  UserPrincipalName,
                  Mail,
                  @{ Name = "Enabled"; Expression = { $_.AccountEnabled } } |
    Format-Table -AutoSize