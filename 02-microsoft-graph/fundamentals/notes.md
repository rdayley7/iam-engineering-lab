# Microsoft Graph Fundamentals — Notes

## What Microsoft Graph is
Microsoft Graph is the single REST API and endpoint (`https://graph.microsoft.com`)
for reading and writing data across Microsoft 365 and Entra ID — users,
groups, sign-in logs, licenses, devices, and more. Instead of learning a
different API per service, an identity engineer learns Graph once and uses
it for nearly everything in the Microsoft identity stack.

## Graph Explorer
Graph Explorer is a browser tool for trying Graph calls without writing any
code: <https://developer.microsoft.com/graph/graph-explorer>. You sign in,
pick a method and URL, and see the raw JSON response. It's the fastest way
to learn what a request returns and which permissions it needs *before* you
script it.
```
GET https://graph.microsoft.com/v1.0/users
GET https://graph.microsoft.com/v1.0/users?$select=displayName,userPrincipalName
```

## REST API
Every Graph operation is an HTTP request against a resource URL. The verb
says what you're doing; the URL says to what:
- `GET` — read (list users, read one user)
- `POST` — create (new user, new group)
- `PATCH` — update specific fields on an existing object
- `DELETE` — remove an object

`v1.0` is the stable production endpoint; `beta` has newer, unfinished
features and shouldn't be relied on for real automation.

## Query parameters
Graph URLs take OData query parameters to shape the response — the same
ideas as filtering and selecting in PowerShell, but in the URL:
- `$select` — return only the fields you need (faster, less noise)
- `$filter` — server-side filtering (`accountEnabled eq false`)
- `$top` — limit how many results come back
- `$count` / `$search` — count and search (often need the `ConsistencyLevel` header)
```
GET /users?$filter=accountEnabled eq false&$select=displayName,userPrincipalName
```

## The Graph PowerShell SDK
The SDK wraps those REST calls in PowerShell cmdlets so you don't hand-build
HTTP requests. The naming maps directly onto the REST verbs:
| REST | SDK cmdlet |
|------|-----------|
| `GET /users` | `Get-MgUser` |
| `POST /users` | `New-MgUser` |
| `PATCH /users/{id}` | `Update-MgUser` |
| `DELETE /users/{id}` | `Remove-MgUser` |
| `GET /groups` | `Get-MgGroup` |

Install it once, then connect (see `../SETUP.md`):
```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "User.Read.All"
```

## Authentication
Two ways a script proves who it is:
- **Delegated** — the script acts *as a signed-in user*. `Connect-MgGraph`
  with an interactive sign-in is delegated. Good for learning and for tools
  a person runs. The effective permissions are the intersection of the
  user's rights and the granted scopes.
- **App-only (application)** — the script acts *as itself* using an app
  registration (client ID + a certificate or secret), no human present.
  This is how unattended/scheduled automation runs in production.

This phase uses delegated auth to keep the focus on Graph itself.

## Permissions and scopes
Graph enforces permission on every call. **Scopes** are the permission
strings you request at connect time — e.g. `User.Read.All`,
`User.ReadWrite.All`, `Group.Read.All`. Rules of thumb:
- `.Read` lets you list/read; `.ReadWrite` is required to create, update, or delete.
- `.All` means directory-wide (every user), versus just the signed-in user.
- Request the **least privilege** that gets the job done. Read scripts should
  ask for `.Read`, not `.ReadWrite`.
- Directory-wide and write scopes usually require **admin consent** — which
  you can grant because you own the lab tenant.
```powershell
# Reading users needs only:
Connect-MgGraph -Scopes "User.Read.All"

# Creating or disabling users needs write access:
Connect-MgGraph -Scopes "User.ReadWrite.All"
```

## Why this matters for IAM
Provisioning, deprovisioning, access reporting, stale-account cleanup, and
license audits are all just Graph calls underneath. Learning Graph turns
the manual portal work from Phase 1's world into repeatable, reviewable
automation — the difference between clicking through the admin center and
engineering identity operations.
