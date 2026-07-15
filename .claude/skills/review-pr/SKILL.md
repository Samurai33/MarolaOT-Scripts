---
name: review-pr
description: Review a pull request in a fresh context for correctness, evidence, security, licensing, maturity, tests, and scope.
disable-model-invocation: true
argument-hint: "[pr-number]"
---

Review PR `$ARGUMENTS` using a fresh read-only reviewer subagent.

Inspect:
- linked issue and acceptance criteria;
- base/head and changed-file inventory;
- source provenance, revisions, hashes, and licenses;
- maturity claims and missing gates;
- executable/configuration attack surface;
- backup/rollback and safe defaults;
- schema/validator/test changes;
- secrets/private data;
- documentation/catalog/changelog consistency;
- CI status and exact failures.

Findings must be:
- reproducible;
- tied to a file/line or missing acceptance item;
- categorized as blocker, required, or optional.

Ignore preferences that do not affect correctness or the stated requirements. Return a merge recommendation and the exact remaining actions.
