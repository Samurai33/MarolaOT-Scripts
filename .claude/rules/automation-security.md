---
paths:
  - ".claude/**"
  - ".github/**"
  - "scripts/**"
  - "**/install/**"
  - "**/rollback/**"
---

# Automation security

- Repository configuration is an execution surface; review it as code.
- Never add broad `allow` permission rules for Bash, PowerShell, MCP, Write, Edit, or Agent.
- Never use `bypassPermissions`.
- Hooks must parse stdin defensively, fail closed only for clearly dangerous operations, and avoid network access.
- Project hooks are opt-in until reviewed on the target machine.
- Use permission deny rules for static boundaries and hooks only for dynamic checks.
- Block secret files, destructive Git operations, recursive forced deletion, and unreviewed remote execution.
- Avoid commands that download and immediately execute content.
- Pin GitHub Actions to trusted major versions or immutable SHAs according to repository policy.
- Keep CI permissions read-only unless a job explicitly requires writes.
- Any generated file must be validated before it becomes an input to another privileged action.
