# AI Agent Rules

## Orchestration design

- Split multi-agent systems by responsibility, not implementation convenience — a monolithic agent handling an entire workflow is as much a code smell as a monolithic service (`ai/rules/architecture.md`).
- Choose deliberately between an LLM-reasoning agent (flexible, non-deterministic problem-solving) and a deterministic workflow/graph node (fixed, predictable orchestration) — don't reach for an LLM decision where a plain `if`/state machine is more reliable and cheaper.
- Model choice, temperature, and provider are configurable (env/config), never hardcoded in agent code — swapping models for cost/quality experiments shouldn't require a code change.
- Justify agent/orchestration complexity the same way `ai/rules/engineering.md`'s anti-over-engineering section asks for any abstraction: a single well-prompted agent or a plain function is often better than a multi-agent system built because it's fashionable.

## Tools

- Give every tool a narrow, typed input/output schema (Pydantic models are the natural fit here — see PydanticAI below) — a tool with a loosely-typed `dict` in/out invites silent misuse.
- Validate tool arguments before executing any side-effecting call — the same input-validation discipline as an API handler (`ai/rules/api-design.md`), because a tool call is effectively an API request the LLM constructs.
- Separate credential/secret management from prompts entirely — a tool's credentials come from the same source as any other service (`ai/rules/security.md`, Azure Key Vault), never embedded in a prompt template or passed through the LLM.
- Return structured, actionable errors from tools (distinguish retriable vs terminal failures) so the calling agent/graph can react correctly — a bare exception string gives the agent nothing to act on.
- **Never enforce authorization or safety constraints via prompt instructions alone** ("don't let the agent delete production data" as a system-prompt line is not a security control). Enforce access control at the tool/infrastructure layer — the tool itself checks permissions and tenant scope before acting, exactly like `ai/rules/rbac.md` requires for any other code path.

## Prompt injection & untrusted input

- Treat any content an agent will read that originated from a user, a document, a web page, or a tool result as untrusted input — the same posture as SQL/XSS input handling (`ai/rules/security.md`), because it can contain instructions trying to hijack the agent.
- Keep a clear structural boundary between system instructions and untrusted content (explicit delimiters, separate message roles) — never concatenate untrusted text directly into the system prompt.
- A tool call driven by untrusted content still goes through the same authorization/validation path as a user-initiated one — an agent "convinced" by injected text to call a sensitive tool must still fail the same permission check a legitimate call would.

## State & memory

- Separate session state (current conversation/task) from persistent memory (cross-session recall) — don't conflate the two into one blob.
- Keep state small and serializable; store large outputs (generated files, long documents, images) externally and reference them by ID/URL in state, don't embed them inline.
- State keys/shape are intentional and documented, not an ad hoc grab-bag that grows implicitly as the agent evolves.

## Cost, latency, and caching

- Log token usage, estimated cost, model name, and latency for every LLM call, alongside the standard structured-log fields (`ai/rules/observability.md`) — cost/latency are first-class operational metrics for an agent system, not an afterthought.
- Cache LLM responses for deterministic/idempotent prompts (same input, same expected output) to cut cost and latency — same cache-invalidation discipline as `ai/rules/caching.md`.
- Set explicit timeouts on every LLM call — an agent waiting indefinitely on a hung provider call blocks the same way an unbounded outbound HTTP call does (`ai/rules/performance.md`).

## Testing

- Test agent routing/tool-selection decisions and unsafe-tool-invocation prevention with automated tests, not just manual prompt exploration — mock the LLM response and assert on which tool the agent selected and with what arguments.
- Test tool implementations directly (given these inputs, does the tool behave correctly, including its error path) independent of any specific agent that calls them.

## Framework-specific notes

- **LangGraph**: model non-trivial control flow (branching, retries, human-in-the-loop, multi-step plans) as an explicit state graph (nodes + edges) rather than an ad hoc `while` loop — use its checkpointing for anything that needs to resume after a pause or failure.
- **PydanticAI**: define agent inputs, outputs, and tool signatures as Pydantic models so validation is automatic and consistent with how the same models validate FastAPI requests/responses (`ai/rules/python-fastapi.md`) — reuse the same model definitions where the agent and API share a domain concept, don't duplicate them.
- **LangChain**: treat prompt templates as versioned, testable assets in a dedicated module (not inline magic strings) — unit test a chain like any other function, with the LLM call mocked to a fixed response, asserting on the chain's parsing/branching logic rather than on live model output.
