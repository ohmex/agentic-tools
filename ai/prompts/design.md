# Prompt: Design

Use this prompt for cross-cutting or architecturally significant design work.

1. **Frame the problem.** What is the goal, what constraints exist (tenancy, latency, compliance), and who are the stakeholders?
2. **Survey existing architecture.** Read `ai/context/architecture.md` and identify affected services and their owned data.
3. **Generate options.** Produce at least two viable approaches with tradeoffs (complexity, cost, latency, operational burden).
4. **Recommend one**, with reasoning, and call out risks explicitly.
5. **Write it up as an ADR** using `ai/templates/adr.md` or an RFC using `ai/templates/rfc.md` for larger, multi-team decisions.
6. **Identify migration/rollout plan**, including backward compatibility and a rollback path.
7. **Flag security and tenancy implications** explicitly — do not leave these implicit.
