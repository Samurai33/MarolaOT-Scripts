# Claude Code Workspace

This directory contains the project-scoped Claude Code configuration.

## Load model

| Mechanism | Location | Loads | Use |
|---|---|---|---|
| Core instructions | `../CLAUDE.md` | Every session | Non-negotiable repository behavior |
| Rules | `rules/*.md` | When matching paths are read | File/domain-specific constraints |
| Skills | `skills/*/SKILL.md` | On explicit invocation | Repeatable procedures |
| Subagents | `agents/*.md` | Only when delegated | Isolated research/review contexts |
| Settings | `settings.json` | Every trusted session | Enforced permission boundaries |
| Hooks | `hooks/` | Only after explicit opt-in | Deterministic runtime checks |
| Token budget | `token-budget.json` | On demand | Measurement and routing policy |

Do not import all documentation into `CLAUDE.md`. Imports are expanded at startup and do not save tokens.

## First-time setup

1. Follow [`../docs/claude/INSTALLATION.md`](../docs/claude/INSTALLATION.md).
2. Open the repository root.
3. Review `CLAUDE.md`, `.claude/settings.json`, skills, agents, workflows, and hooks.
4. Accept workspace trust only after review.
5. Run `/doctor`.
6. Run `/memory` and confirm the expected instruction files.
7. Run `/context` to inspect startup overhead.
8. Keep hooks disabled initially; follow [`hooks/README.md`](hooks/README.md) to opt in.
9. Validate the workspace with `python .claude/validation/validate_claude_workspace.py`.
10. Start work from a GitHub issue.

## Commands

- `/issue-to-pr 13`
- `/research-reference <hunt-or-quest>`
- `/create-hunt-package <slug>`
- `/create-quest-package <slug>`
- `/validate-package <path>`
- `/quality-loop <acceptance-check>`
- `/review-pr <number>`
- `/token-audit <task-id>`

## Documentation

- [`../docs/claude/README.md`](../docs/claude/README.md): architecture and daily operation.
- [`../docs/claude/INSTALLATION.md`](../docs/claude/INSTALLATION.md): Windows setup, trust, hooks, and rollback.
- [`../docs/claude/OPERATING_MODEL.md`](../docs/claude/OPERATING_MODEL.md): task classes and handoffs.
- [`../docs/claude/SKILLS_AND_AGENTS.md`](../docs/claude/SKILLS_AND_AGENTS.md): complete command and routing reference.
- [`../docs/claude/LOOPS.md`](../docs/claude/LOOPS.md): recurring `/loop` versus bounded `/quality-loop`.
- [`../docs/claude/TOKEN_EFFICIENCY.md`](../docs/claude/TOKEN_EFFICIENCY.md): measurable optimization strategy.
- [`../docs/claude/METRICS.md`](../docs/claude/METRICS.md): benchmark template.
- [`../docs/claude/SECURITY.md`](../docs/claude/SECURITY.md): trust and permission model.
- [`../docs/claude/TROUBLESHOOTING.md`](../docs/claude/TROUBLESHOOTING.md): diagnostic runbook.

## Safety

Project settings contain deny/ask rules, not broad allow rules. They are a guardrail, not a sandbox. Review every external skill, hook, MCP server, and repository before trust.

## Maintenance

- Keep root `CLAUDE.md` below 200 lines.
- Keep skill bodies focused; move large examples to supporting docs.
- Remove stale or conflicting rules.
- Run `.claude/validation/validate_claude_workspace.py` after changing this directory.
- Audit official references at least quarterly or after a major Claude Code release.
