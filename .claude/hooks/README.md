# Optional Claude Code Hooks

Hooks are executable repository configuration. They are **not enabled** by `.claude/settings.json`.

## Enable safely

1. Review every script in this directory.
2. Confirm PowerShell path and execution policy on the target Windows machine.
3. Copy the `hooks` object from `.claude/settings.hooks.example.json` into `.claude/settings.local.json`.
4. Keep the local settings file uncommitted.
5. Run `/hooks` and confirm each event, matcher, source, and command.
6. Test against harmless examples before real work.
7. Remove the local hook configuration immediately if behavior is unexpected.

## Hooks

- `pretool-security.ps1`: blocks clear destructive commands and sensitive file paths.
- `posttool-validate.ps1`: validates a changed JSON/PowerShell/Markdown file when possible.
- `instructions-loaded.ps1`: writes a local audit log under `.claude/runtime/`.

## Design constraints

- stdin is treated as untrusted JSON;
- no network access;
- no external package installation;
- no auto-approval;
- no file mutation outside `.claude/runtime/`;
- exit 2 only for explicit security blocks;
- validation failures are reported without deleting or rewriting user files.

Hooks complement permission deny rules; they do not replace them.
