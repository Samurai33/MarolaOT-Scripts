---
name: issue-to-pr
description: Execute one GitHub issue through scoped research, branch work, validation, and a reviewable pull request.
disable-model-invocation: true
argument-hint: "[issue-number]"
---

Work on GitHub issue `$ARGUMENTS`.

1. Read the issue, comments, current repository status, related packages, catalog, changelog, and open PRs.
2. Restate the acceptance criteria and identify the current maturity level.
3. Refuse to implement missing facts as guesses; create a research blocker instead.
4. Create or use one scoped branch with a conventional prefix.
5. Plan the smallest reversible change and the exact validation commands.
6. Implement in coherent commits; keep unrelated cleanup out.
7. Run focused checks, repository-wide checks, secret review, and diff review.
8. Use a fresh reviewer subagent for correctness, safety, licensing, and scope.
9. Open/update the PR with:
   - issue link;
   - summary and maturity impact;
   - sources and immutable revisions;
   - file inventory;
   - security and rollback;
   - exact tests and outcomes;
   - unresolved manual gates.
10. Do not merge unless the user explicitly requests it and required checks are green.

Return the issue, branch, commits, PR, checks, blocked gates, and next action.
