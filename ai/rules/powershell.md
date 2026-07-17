# PowerShell Rules

- Use approved verb-noun cmdlet naming for functions (`Get-Verb` lists the approved set) — e.g. `Get-TenantConfig`, not `FetchTenantConfig` or `TenantConfigGet`.
- Start every script with `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'` so failures surface immediately instead of silently continuing with a partial/undefined state.
- Avoid aliases (`ls`, `%`, `?`, `gci`) in scripts meant to be committed/shared — use full cmdlet names (`Get-ChildItem`, `ForEach-Object`, `Where-Object`) for readability and forward compatibility.
- Use `[CmdletBinding()]` and typed, validated parameters (`[Parameter(Mandatory)]`, `[ValidateSet(...)]`, `[ValidateNotNullOrEmpty()]`) instead of manually checking `$null`/empty inside the function body.
- Don't use `Write-Host` for anything other than genuinely user-facing CLI output — use `Write-Output`/`Write-Verbose`/`Write-Error` so output can be piped, captured, and tested; `Write-Host` bypasses the pipeline entirely.
- Wrap external/destructive operations (deletes, deployments, force-pushes) with `-WhatIf`/`-Confirm` support (`SupportsShouldProcess`) so they can be dry-run before executing for real.
- Prefer PowerShell's built-in cmdlets and `.NET` types over shelling out to external tools when a native equivalent exists — but when shelling out is necessary, check the exit code explicitly (`$LASTEXITCODE`) rather than assuming success.
- Add comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`) to any script/function intended for reuse by others, not just inline comments.
- Test scripts with Pester — cover both the happy path and failure/edge cases (missing parameter, unreachable resource, permission denial) the same way `ai/rules/testing.md` expects for application code.
- Never hardcode credentials or connection strings — pull secrets from the same source application code does (Azure Key Vault, `ai/rules/azure.md`), not a plaintext config file checked into the repo.
