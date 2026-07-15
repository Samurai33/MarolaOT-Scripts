---
name: token-audit
description: Measure and improve Claude Code context/token efficiency for a repeatable task using a baseline rather than an unsupported savings claim.
disable-model-invocation: true
argument-hint: "[task-id]"
---

Audit token efficiency for task `$ARGUMENTS`.

Baseline:
- run the representative task in a fresh session;
- record model, `/usage`, `/context`, duration, cache creation/read tokens, output tokens, and pass/fail;
- record loaded CLAUDE.md/rules/MCP/skills.

Optimize one variable at a time:
- trim always-loaded instructions;
- move procedures to skills;
- scope rules by path;
- delegate large reads/logs;
- preprocess output with local tools/hooks;
- disable unused MCP servers;
- use a cheaper model for bounded work;
- use `/clear` or focused `/compact`;
- avoid cache-invalidating configuration changes.

Re-run the same task and calculate:
`reduction = (baseline - optimized) / baseline * 100`.

A 40–70% target is acceptable only for repetitive workflows with measured evidence. Do not generalize one benchmark to every task.

Save results using `docs/claude/METRICS.md` and recommend keep/revert for each optimization.
