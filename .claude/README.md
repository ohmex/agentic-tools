# .claude — Claude Code adapters (generated locally)

This folder is **not populated in git**. After clone, run:

```powershell
powershell -File ai/scripts/sync-adapters.ps1
```

That creates:

| Path | Source |
|------|--------|
| `rules/*.md` | `ai/rules/manifest.json` + inlined bodies |
| `skills/` | Copy of `ai/skills/` |
| `agents/*.md` | Inlined `ai/agents/` bodies |

`settings.local.json` is for personal overrides (gitignored).

Edit [`ai/`](../ai/README.md), not generated files here.

## Clean up

```powershell
powershell -File ai/scripts/clean-adapters.ps1
```
