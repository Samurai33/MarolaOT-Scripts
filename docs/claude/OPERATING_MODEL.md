# Claude Operating Model

## Task classes

### T0 — lookup

One fact, file, path, or status. Use Haiku/read-only tools. No branch unless a repository change follows.

### T1 — small change

One to three files with a deterministic check. Use Sonnet, a targeted skill, and focused validation.

### T2 — package change

Manifest/source changes plus implementation/tests/docs. Use plan mode, researcher + reviewer subagents, and `/issue-to-pr`.

### T3 — release, migration, or security work

Cross-cutting, state-changing, or externally published work. Use an explicit plan, isolated research, architecture review, security review, full CI, rollback, and human merge decision.

## Issue-to-PR state machine

`issue → evidence → plan → branch → implementation → focused checks → regression checks → independent review → PR → CI → human merge`

No state may silently imply the next one.

## Context phases

Do not keep an entire project lifecycle in one conversation.

1. **Research session:** sources and blockers; save evidence.
2. **Implementation session:** clear context; read issue/plan and changed files only.
3. **Review session/subagent:** fresh context; inspect diff and criteria.
4. **Release session:** clear context; verify release artifacts and operational evidence.

Use `/rename` before `/clear` when the session may need to be resumed.

## Model routing

- Haiku: inventory, narrow search, link audit, token audit, document consistency.
- Sonnet: normal coding, package architecture, validation fixes, PR preparation.
- Opus: only hard architecture, ambiguous multi-system reasoning, or repeated Sonnet failure with a clear question.

Do not switch models repeatedly inside one task; model changes can reduce cache reuse.

## Evidence discipline

Every external fact should be one of:

- primary source;
- immutable source code;
- community reference;
- inference;
- provisional local observation;
- validated MarolaOT evidence.

Store the category, revision, and limitations.

## Handoff contract

Before ending or compacting a long task, preserve:

- issue and branch;
- objective and acceptance criteria;
- current maturity;
- files changed;
- immutable sources/hashes/licenses;
- checks and outcomes;
- manual gates;
- next exact command/action.

## Stop conditions

Stop and report rather than improvise when:

- a source is missing or license is unclear;
- a required coordinate/item/storage is unvalidated;
- a destructive or irreversible action is requested outside scope;
- CI failure cannot be reproduced;
- credentials/private data appear;
- the same root cause repeats twice;
- the context no longer contains reliable task state.
