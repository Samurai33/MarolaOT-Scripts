# Claude Code Engineering Guide

Audited against official Anthropic documentation on **2026-07-15**.

## Architecture decision

Use the lightest mechanism that satisfies the requirement:

| Need | Mechanism | Token behavior | Enforcement |
|---|---|---|---|
| Essential fact for every task | Root `CLAUDE.md` | Always loaded | Behavioral |
| File/domain-specific convention | `.claude/rules/` with `paths:` | Loads on matching reads | Behavioral |
| Repeatable procedure | `.claude/skills/` | Body loads on use | Behavioral |
| High-volume side task | `.claude/agents/` | Separate context; summary returns | Tool/permission scoped |
| Deterministic lifecycle action | Hook | No model decision required | Executable |
| Hard static boundary | Permission deny/ask | No prompt tokens for hidden denied tools | Client-enforced |
| External tool integration | MCP | Tool metadata can consume context | Client/tool-enforced |

## Why this structure

Anthropic recommends keeping `CLAUDE.md` concise and under 200 lines. Detailed procedures belong in skills because their bodies load only when invoked. Path-scoped rules reduce noise, and subagents keep broad searches/logs outside the main context.

## Daily workflow

1. Start from the issue.
2. Run `/memory` and `/context`.
3. Use plan mode for complex work.
4. Use a targeted skill.
5. Delegate broad research or independent review.
6. Run deterministic validation.
7. Use `/compact <focus>` before a long second phase.
8. Use `/clear` before unrelated work.
9. Run `/token-audit` on repeated workflows.
10. Open/update the PR with exact evidence.

## Verification and recurring loops

A good task includes a check Claude can run. The quality loop is:

`implement → run narrow check → read failure → fix root cause → rerun → regression checks → fresh-context review`

Use `/quality-loop` for the bounded repair workflow. Use the bundled `/loop` only for controlled recurring read-only checks during an active session. The differences and safety boundaries are documented in [`LOOPS.md`](LOOPS.md).

## Workspace trust

Repository skills, hooks, and settings are an execution surface. Review them before accepting trust. This repository enables only static deny/ask rules by default. Hooks remain opt-in through local settings.

## Diagnostic commands

- `/doctor`: setup and duplicate configuration checks.
- `/memory`: loaded instruction files and auto memory.
- `/context`: context breakdown and optimization hints.
- `/usage`: token/plan usage.
- `/permissions`: effective allow/ask/deny rules.
- `/hooks`: configured hook browser.
- `/agents`: subagent management.
- `/clear`: fresh context for unrelated work.
- `/compact <focus>`: focused history summarization.

Confirm installed bundled-command syntax through `/help` after Claude Code upgrades.

## Official references

- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/hooks-guide
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/costs
- https://code.claude.com/docs/en/context-window
- https://code.claude.com/docs/en/prompt-caching
- https://code.claude.com/docs/en/best-practices

Re-audit these links after major Claude Code releases.
