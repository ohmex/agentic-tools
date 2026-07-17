# agentic-tools

Shared AI engineering assets for **Cursor** and **Claude Code**. Use as a project template or copy `ai/` into an existing repo.

Canonical AI guidance lives under `ai/`. Generated tool adapters are created locally — not committed.

## What's in git

```text
ai/                    # Source of truth — edit here
  rules/*.md           # Rule bodies
  rules/manifest.json  # Rule metadata (globs, alwaysApply, description)
  skills/ agents/ context/ examples/ templates/ checklists/ prompts/ mcp/
  scripts/sync-adapters.ps1
  scripts/clean-adapters.ps1

.cursor/README.md      # Pointer only
.claude/README.md      # Pointer only
```

Generated adapter folders (`.cursor/rules`, `.cursor/agents`, `.claude/*`) are **gitignored**.

## Source of truth (`ai/`)

| Path | Contents |
|------|----------|
| `ai/rules/` | Coding standards (`manifest.json` + `*.md` bodies) |
| `ai/skills/` | Agent Skills (`SKILL.md` packages) |
| `ai/agents/` | Subagent personas |
| `ai/context/` | Architecture, domain, tenancy, glossary |
| `ai/examples/` | Canonical code patterns |
| `ai/templates/` | ADR, RFC, migration, runbook skeletons |
| `ai/checklists/` | DoD, release, review checklists |
| `ai/prompts/` | Task recipes |

### Always-on standards

- `ai/rules/engineering.md`
- `ai/rules/security.md`
- `ai/rules/testing.md`

## New project bootstrap

```powershell
git clone <this-repo> my-project
cd my-project

# Customize ai/context/, ai/rules/, etc. for your project

powershell -File ai/scripts/sync-adapters.ps1
```

That generates `.cursor/rules`, `.cursor/agents`, `.claude/rules`, `.claude/skills`, and `.claude/agents` from `ai/`. Open the folder and start work.

Re-run sync after any change under `ai/rules/`, `ai/skills/`, or `ai/agents/`.

## Clean up generated adapters

```powershell
powershell -File ai/scripts/clean-adapters.ps1
```

Keeps only `.cursor/README.md` and `.claude/README.md`. Regenerate with sync when needed.

Do not hand-edit generated files under `.cursor/` or `.claude/` — change `ai/` and re-run sync.

## Adding a new rule

1. Add `ai/rules/<name>.md` (body only).
2. Add an entry to `ai/rules/manifest.json` (`name`, `description`, and either `alwaysApply: true` or `paths: [...]`).
3. Run `powershell -File ai/scripts/sync-adapters.ps1`.

See [`ai/README.md`](ai/README.md) for details.
