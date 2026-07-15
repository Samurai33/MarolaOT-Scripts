---
name: validate-package
description: Run focused and repository-wide validation for a hunt, quest, schema, script, or documentation package.
disable-model-invocation: true
argument-hint: "[path]"
---

Validate `$ARGUMENTS`.

Build a changed-file inventory, then run only applicable checks:

- JSON parse and schema validation;
- semantic validators and negative fixtures;
- PowerShell parser and PSScriptAnalyzer;
- CaveBot static parser;
- manifest/source-lock consistency;
- forbidden executable content for M0–M2;
- inventory/checksum verification;
- Markdown path/link checks;
- secret and private-data scan;
- `git diff --check`;
- package-specific CI-equivalent commands.

Do not truncate failures to a misleading summary. Preserve the first actionable error and its file/line.

Return:
- exact commands;
- pass/fail/not-run per check;
- affected maturity gate;
- minimal fix;
- whether the package is PR-ready.
