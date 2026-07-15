---
paths:
  - "**/*.ps1"
  - "**/*.psm1"
  - "**/*.psd1"
---

# PowerShell

- Target PowerShell 7 where possible and document Windows PowerShell compatibility when required.
- Start operational scripts with strict error handling.
- Use `CmdletBinding()` and `SupportsShouldProcess` for state-changing scripts.
- Validate all paths and required files before mutation.
- Back up before write; use a timestamped, inspectable backup directory.
- Write temporary output first, validate it, then replace the target atomically.
- On failure after mutation begins, attempt rollback and report both original and rollback errors.
- Never embed credentials, account data, private IPs, or local secrets.
- Keep all vBot modules disabled after install or restore.
- Provide clear exit codes and a final machine-readable summary where practical.
- Parse with PowerShell and run PSScriptAnalyzer before PR completion.
- Do not suppress analyzer rules globally to hide defects; document narrow exceptions.
