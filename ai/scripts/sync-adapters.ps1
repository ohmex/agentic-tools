#!/usr/bin/env pwsh
<#
.SYNOPSIS
  Bootstrap Cursor and Claude adapters from the ai/ source of truth.

.DESCRIPTION
  Reads ai/rules/manifest.json and ai/ content, then generates:
    .cursor/rules/*.mdc   (Cursor frontmatter + @ai/rules/…)
    .cursor/agents/*.md   (frontmatter + @ai/agents/…)
    .claude/rules/*.md    (Claude frontmatter + inlined bodies)
    .claude/skills/       (copy of ai/skills/)
    .claude/agents/*.md   (Claude frontmatter + inlined bodies)

  All generated adapter trees are gitignored. Commit only ai/ + manifest.

  Run from repo root after clone or after editing ai/:
    powershell -File ai/scripts/sync-adapters.ps1
#>
[CmdletBinding()]
param(
  [string]$RepoRoot = ''
)

if (-not $RepoRoot) {
  $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir '..\..')).Path
}

$ErrorActionPreference = 'Stop'

function Write-Utf8NoBom([string]$Path, [string]$Content) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }
  [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
}

function Copy-Tree([string]$Source, [string]$Destination) {
  if (Test-Path $Destination) {
    Remove-Item -Recurse -Force $Destination
  }
  New-Item -ItemType Directory -Force -Path $Destination | Out-Null
  if (Test-Path $Source) {
    Copy-Item -Path (Join-Path $Source '*') -Destination $Destination -Recurse -Force
  }
}

function Format-Globs([array]$Paths) {
  if (-not $Paths -or $Paths.Count -eq 0) { return $null }
  $quoted = $Paths | ForEach-Object { "`"$_`"" }
  return "[$($quoted -join ', ')]"
}

Write-Host "Repo root: $RepoRoot"

# --- Load manifest (source of truth for rule metadata) ------------------------
$manifestPath = Join-Path $RepoRoot 'ai\rules\manifest.json'
if (-not (Test-Path $manifestPath)) {
  throw "Missing manifest: $manifestPath - add rule metadata there before syncing."
}

$manifest = Get-Content $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
if (-not $manifest.rules) {
  throw "manifest.json has no 'rules' array."
}

Write-Host "Loaded manifest: $($manifest.rules.Count) rules"

# --- Cursor rules -----------------------------------------------------------
$cursorRulesDir = Join-Path $RepoRoot '.cursor\rules'
New-Item -ItemType Directory -Force -Path $cursorRulesDir | Out-Null

$expectedRules = @{}
foreach ($rule in $manifest.rules) {
  $expectedRules[$rule.name] = $true
  $bodyPath = Join-Path $RepoRoot "ai\rules\$($rule.name).md"
  if (-not (Test-Path $bodyPath)) {
    throw "Missing rule body: ai/rules/$($rule.name).md (listed in manifest.json)"
  }

  $fm = @('---')
  if ($rule.description) {
    $fm += "description: $($rule.description)"
  }
  if ($rule.alwaysApply) {
    $fm += 'alwaysApply: true'
  } elseif ($rule.paths) {
    $globs = Format-Globs @($rule.paths)
    $fm += "globs: $globs"
  } else {
    $fm += 'alwaysApply: false'
  }
  $fm += '---'
  $fm += ''
  $fm += "@ai/rules/$($rule.name).md"
  $fm += ''

  $out = Join-Path $cursorRulesDir "$($rule.name).mdc"
  Write-Utf8NoBom $out ($fm -join "`n")
  Write-Host "Generated Cursor rule: $($rule.name).mdc"
}

Get-ChildItem $cursorRulesDir -Filter '*.mdc' -ErrorAction SilentlyContinue | ForEach-Object {
  $n = [IO.Path]::GetFileNameWithoutExtension($_.Name)
  if (-not $expectedRules.ContainsKey($n)) {
    Remove-Item $_.FullName -Force
    Write-Host "Removed stale Cursor rule: $($_.Name)"
  }
}

# --- Claude rules -----------------------------------------------------------
$claudeRulesDir = Join-Path $RepoRoot '.claude\rules'
New-Item -ItemType Directory -Force -Path $claudeRulesDir | Out-Null

foreach ($rule in $manifest.rules) {
  $bodyPath = Join-Path $RepoRoot "ai\rules\$($rule.name).md"
  $body = [System.IO.File]::ReadAllText($bodyPath, [System.Text.UTF8Encoding]::new($false))

  $fm = @('---')
  if ($rule.description) {
    $fm += "description: $($rule.description)"
  }
  if ($rule.alwaysApply) {
    $fm += 'alwaysApply: true'
  }
  if ($rule.paths) {
    $fm += 'paths:'
    foreach ($p in $rule.paths) {
      $fm += "  - `"$p`""
    }
  }
  $fm += '---'
  $fm += ''

  $content = ($fm -join "`n") + $body
  if (-not $content.EndsWith("`n")) { $content += "`n" }

  $out = Join-Path $claudeRulesDir "$($rule.name).md"
  Write-Utf8NoBom $out $content
  Write-Host "Generated Claude rule: $($rule.name).md"
}

Get-ChildItem $claudeRulesDir -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
  $n = [IO.Path]::GetFileNameWithoutExtension($_.Name)
  if (-not $expectedRules.ContainsKey($n)) {
    Remove-Item $_.FullName -Force
    Write-Host "Removed stale Claude rule: $($_.Name)"
  }
}

# --- Skills sync ------------------------------------------------------------
$skillsSrc = Join-Path $RepoRoot 'ai\skills'
$claudeSkills = Join-Path $RepoRoot '.claude\skills'
Copy-Tree $skillsSrc $claudeSkills
Write-Host 'Synced skills -> .claude/skills'

$cursorSkills = Join-Path $RepoRoot '.cursor\skills'
if (Test-Path $cursorSkills) {
  Remove-Item -Recurse -Force $cursorSkills
  Write-Host 'Removed obsolete .cursor/skills'
}

# --- Agent wrappers ---------------------------------------------------------
$agentsSrc = Join-Path $RepoRoot 'ai\agents'
$cursorAgents = Join-Path $RepoRoot '.cursor\agents'
$claudeAgents = Join-Path $RepoRoot '.claude\agents'
New-Item -ItemType Directory -Force -Path $cursorAgents | Out-Null
New-Item -ItemType Directory -Force -Path $claudeAgents | Out-Null

$expectedAgents = @{}
Get-ChildItem $agentsSrc -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
  $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)
  $expectedAgents[$name] = $true
  $body = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))

  $description = "Specialist agent: $name"
  if ($body -match '(?m)^#\s+(.+)$') {
    $description = $Matches[1].Trim()
  }

  $atAgent = '@ai/agents/' + $name + '.md'
  $cursorContent = "---`n" + "description: $description`n" + "---`n`n" + $atAgent + "`n"
  Write-Utf8NoBom (Join-Path $cursorAgents "$name.md") $cursorContent

  $claudeContent = "---`n" + "name: $name`n" + "description: $description`n" + "---`n`n" + $body
  if (-not $claudeContent.EndsWith("`n")) { $claudeContent += "`n" }
  Write-Utf8NoBom (Join-Path $claudeAgents "$name.md") $claudeContent

  Write-Host "Generated agent wrappers: $name"
}

Get-ChildItem $cursorAgents -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
  $n = [IO.Path]::GetFileNameWithoutExtension($_.Name)
  if (-not $expectedAgents.ContainsKey($n)) {
    Remove-Item $_.FullName -Force
    Write-Host "Removed stale Cursor agent: $($_.Name)"
  }
}

Get-ChildItem $claudeAgents -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
  $n = [IO.Path]::GetFileNameWithoutExtension($_.Name)
  if (-not $expectedAgents.ContainsKey($n)) {
    Remove-Item $_.FullName -Force
    Write-Host "Removed stale Claude agent: $($_.Name)"
  }
}

Write-Host ''
Write-Host 'Bootstrap complete.'
Write-Host '  .cursor/rules, .cursor/agents  (gitignored)'
Write-Host '  .claude/rules, .claude/skills, .claude/agents  (gitignored)'
Write-Host 'Edit ai/ and ai/rules/manifest.json, then re-run this script.'
