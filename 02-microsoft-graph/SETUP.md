# Phase 2 Setup — Tenant, PowerShell 7, and the Graph SDK

Everything in Phase 2 runs against a real Microsoft Entra ID tenant using
the **Microsoft Graph PowerShell SDK**. This guide gets you a free tenant
and a working environment. It all works on macOS — a Windows machine is
**not** required.

Do this once, then every exercise in this folder just runs.

---

## 1. Get a free tenant

You need a directory of your own where you can safely create, edit, and
delete test users and groups. Two options:

### Recommended — a free Microsoft Entra ID tenant

The Entra ID **Free** tier costs nothing and lets you create users and
groups, which is all Phase 2 needs.

1. Go to the **Microsoft Entra admin center**: <https://entra.microsoft.com>
2. Sign in with any Microsoft account (a personal `outlook.com` account is fine).
3. In the left menu, open **Identity → Overview → Manage tenants**, then
   choose **Create**.
4. Pick tenant type **Microsoft Entra ID** and select **Next**.
5. Fill in an **Organization name** (e.g. `IAM Lab`), an **Initial domain
   name** (e.g. `iamlabrdayley`, which becomes `iamlabrdayley.onmicrosoft.com`),
   and your country, then **Review + create**.
6. Complete the verification prompt. Your tenant is created in a minute or two.

You are the **Global Administrator** of this new tenant, so you can grant
the permissions the scripts ask for later.

> Microsoft's own step-by-step (the UI shifts occasionally, so follow the
> live version if a label has moved):
> <https://learn.microsoft.com/en-us/entra/fundamentals/create-new-tenant>

### Not recommended anymore — Microsoft 365 Developer Program

The old free E5 developer tenant now generally requires a paid **Visual
Studio Professional or Enterprise** subscription. If you already have one,
you can use it; otherwise skip it and use the free Entra tenant above.

---

## 2. Install PowerShell 7 (macOS)

The Graph SDK needs PowerShell 7 (`pwsh`), not the built-in macOS shell.

```bash
# With Homebrew:
brew install --cask powershell

# Verify:
pwsh --version        # expect 7.x
```

No Homebrew? Download the `.pkg` from
<https://github.com/PowerShell/PowerShell/releases> and install it.

Start a PowerShell session any time with `pwsh`.

---

## 3. Install the Microsoft Graph SDK

Inside a `pwsh` session:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

Say yes to the untrusted-repository / NuGet prompts. This is a large module
and can take a few minutes. Confirm it landed:

```powershell
Get-Module Microsoft.Graph -ListAvailable | Select-Object Name, Version | Select-Object -First 1
```

---

## 4. Connect to your tenant

`Connect-MgGraph` opens a browser sign-in and asks for **scopes** — the
permissions the session is allowed to use. Request only what you need
(least privilege). To read users:

```powershell
Connect-MgGraph -Scopes "User.Read.All"
```

The first time you request a scope, you approve a consent screen. Sign in
with the admin account for the tenant you created in step 1.

Check your connection any time:

```powershell
Get-MgContext        # shows the account, tenant, and granted scopes
```

Disconnect when you're done:

```powershell
Disconnect-MgGraph
```

---

## 5. (Optional) Add a few test users

A brand-new tenant only has your admin account. To give the reporting
scripts something to list, add a couple of test users in the Entra admin
center under **Identity → Users → All users → New user → Create new user**.
Later projects in this phase will create and manage users from PowerShell
instead of the portal.

---

## You're ready

Once `Get-MgContext` shows your tenant, open
`exercises/01-list-users/` and follow its README.
