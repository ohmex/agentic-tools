# .cursor — Cursor adapters (generated locally)

This folder is **not populated in git**. After clone, run:

```powershell
powershell -File ai/scripts/sync-adapters.ps1
```

That creates:

| Path | Source |
|------|--------|
| `rules/*.mdc` | `ai/rules/manifest.json` + `@ai/rules/<name>.md` |
| `agents/*.md` | `@ai/agents/<name>.md` |

Skills are loaded from `.claude/skills/` (synced from `ai/skills/`).

Optional: add `.cursor/mcp.json` for live MCP server config (not generated).

## Rule tiers (set in manifest.json)

| Tier | manifest | When it loads |
|------|----------|----------------|
| Always | `alwaysApply: true` | Every request |
| Auto attach | `paths: [...]` | Matching files in context |
| Agent requested | description only | Agent decides by task |

Edit [`ai/`](../ai/README.md), not files here.

## Clean up

```powershell
powershell -File ai/scripts/clean-adapters.ps1
```
