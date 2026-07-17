# ai/ — shared source of truth

Everything Cursor and Claude need lives here. Tool folders are generated locally by the sync script.

## Layout

| Path | Purpose |
|------|---------|
| `rules/*.md` | Rule bodies (no tool frontmatter) |
| `rules/manifest.json` | **Source of truth** for rule metadata: `description`, `alwaysApply`, `paths` (globs) |
| `skills/*/SKILL.md` | Agent Skills packages |
| `agents/*.md` | Subagent personas |
| `context/` | Architecture, domain, tenancy, glossary, etc. |
| `examples/` | Canonical code patterns |
| `templates/` | ADR, RFC, migration, runbook skeletons |
| `checklists/` | DoD, release, review checklists |
| `prompts/` | Task recipes |
| `mcp/` | MCP documentation (live config stays in `.cursor/mcp.json` if used) |
| `scripts/sync-adapters.ps1` | Generate `.cursor/` and `.claude/` adapters locally |
| `scripts/clean-adapters.ps1` | Remove all generated adapters (keep folders clean) |

## Bootstrap (after clone or copy)

```powershell
powershell -File ai/scripts/sync-adapters.ps1
```

## Clean up (remove all generated adapters)

```powershell
powershell -File ai/scripts/clean-adapters.ps1
```

Keeps only `.cursor/README.md` and `.claude/README.md`. Re-run sync when you need adapters again.

Generates (all gitignored):

```text
.cursor/rules/*.mdc     ← manifest + @ai/rules/…
.cursor/agents/*.md     ← @ai/agents/…
.claude/rules/*.md      ← manifest + inlined bodies
.claude/skills/         ← copy of ai/skills/
.claude/agents/*.md     ← inlined bodies
```

Cursor also discovers skills from `.claude/skills/` after sync.

## Editing workflow

1. Edit content under `ai/`.
2. For a **new rule**: add `ai/rules/<name>.md` + an entry in `manifest.json`.
3. Re-run sync.
4. Commit only `ai/` (and `README.md` if you changed project docs).

## manifest.json entry shape

```json
{
  "name": "golang",
  "description": "Go language and idiom rules",
  "alwaysApply": false,
  "paths": ["**/*.go"]
}
```

| Field | Use |
|-------|-----|
| `alwaysApply: true` | Loads on every request (keep few: engineering, security, testing) |
| `paths: [...]` | Auto-attach when matching files are in context (maps to Cursor `globs`) |
| Neither (description only) | Agent-requested — Cursor sets `alwaysApply: false` |

## Do not

- Commit generated `.cursor/rules`, `.cursor/agents`, or `.claude/*` trees.
- Hand-edit generated adapter files — they are overwritten on sync.
- Put rule bodies only in adapter folders — always in `ai/rules/`.
