# MCP Integrations

This folder documents **which MCP server to use for what** and any setup notes specific to this project. It is documentation only — Cursor does not read this folder to discover or configure servers. The actual live MCP server configuration goes in `.cursor/mcp.json` at the repo root (or your global Cursor MCP settings), not here.

## Configured / recommended servers

| MCP | Purpose | When to reach for it |
|---|---|---|
| PostgreSQL | Inspect schema, run read-only queries, review `EXPLAIN` plans | Debugging a slow query, verifying a migration's effect, checking RLS policy behavior — see `ai/agents/database.md` |
| GitHub | Create PRs, review issues, inspect code/history | PR creation/review workflows, checking issue context before starting work |
| Jira | Read and update tickets | Pulling ticket context for a feature/bugfix, updating status |
| Kubernetes | Inspect pods, deployments, events | Debugging a deployment issue, checking rollout status — see `ai/skills/kubernetes/SKILL.md` |
| Docker | View containers and logs | Local debugging of a containerized service |
| Azure | Browse resources and deployments | Checking Key Vault entries, resource configuration, cost — see `ai/rules/azure.md` |
| Terraform | Understand infrastructure state | Before proposing an infra change, check current state rather than assuming |
| OpenAPI | Validate API specs against implementation | Part of the OpenAPI-first workflow, `ai/rules/api-design.md` |
| Playwright | Execute browser tests | Running/debugging E2E tests interactively, `ai/skills/playwright/SKILL.md` |
| Filesystem / Git | Search, diff, and manipulate project files | General repo navigation and git operations |

## Adding a new MCP server

1. Configure the actual server connection in `.cursor/mcp.json` (or Cursor's MCP settings) — that's the file Cursor reads.
2. Add a row to the table above documenting its purpose and when to use it, so the AI (and teammates) know it exists and when it's the right tool.
3. If the server exposes credentials/tokens, source them the same way as any other secret (`ai/rules/security.md`, Azure Key Vault) — never hardcode a token in `mcp.json`.
4. Note any project-specific setup quirks (auth flow, required env vars, headless/CI availability) here — interactively-authenticated servers (e.g. a personal GitHub OAuth session) may be unavailable in headless/CI runs, which is worth flagging so nobody's surprised when a scheduled job can't reach one.
