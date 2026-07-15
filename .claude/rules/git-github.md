---
paths:
  - ".gitignore"
  - ".gitattributes"
  - ".github/**"
  - "docs/EXECUTION_FLOW.md"
  - "CHANGELOG.md"
---

# Git and GitHub

- Never push directly to `main`.
- Use one issue objective per branch and pull request.
- Read the issue, comments, branch state, changed files, and related PRs before mutation.
- Use Conventional Commits with concise, factual messages.
- Do not force-push, reset shared history, or use destructive clean commands.
- Do not merge without an explicit user request and green required checks.
- Keep workflow permissions at `contents: read` unless a documented write is essential.
- Treat changes to `.github/`, `.claude/`, installers, rollback, and release automation as security-sensitive.
- PR descriptions must include evidence, test commands/results, security impact, maturity impact, rollback, and unresolved manual gates.
- Keep an issue open when a PR completes only one maturity stage.
- Avoid drive-by formatting or unrelated refactors in a scoped PR.
- Review the final compare diff, not only individual commits.
