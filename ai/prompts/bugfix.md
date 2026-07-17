# Prompt: Fix a Bug

1. **Reproduce.** Confirm the bug with a failing test before touching implementation code. If it can't be reproduced, say so explicitly rather than guessing at a fix.
2. **Root-cause.** Trace the failure to its origin — don't patch symptoms. Check whether the same root cause affects other call sites (grep for similar patterns).
3. **Fix.** Make the minimal change that addresses the root cause. Do not bundle unrelated refactors into a bugfix.
4. **Regression test.** The reproduction test from step 1 must now pass and stay in the suite permanently.
5. **Check blast radius.** Does this bug pattern exist elsewhere in the codebase (other services, other endpoints)? Flag it even if out of scope for this fix.
6. **Update docs/runbook** if this was a production incident — link the fix to the incident report.
7. **List changed files** with a one-line description of each change and the root cause in one sentence.
