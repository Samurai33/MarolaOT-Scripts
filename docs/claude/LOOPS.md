# Claude Code Loops

Audited against the official Claude Code skills and best-practices documentation on **2026-07-15**.

The project uses two different loop concepts. They must not be confused.

## 1. Official `/loop` — recurring execution

Claude Code ships a bundled `/loop` skill for recurring checks during an active session. Use it for work such as:

- checking a CI run periodically;
- monitoring whether a PR condition changed;
- rerunning a read-only status command;
- reviewing a temporary development signal at a controlled interval.

Before use, open `/help` or the current official skills documentation and confirm the installed syntax because bundled command interfaces can evolve with Claude Code releases.

### Boundaries

- the loop runs only while the Claude Code session remains active;
- do not use it for destructive or irreversible commands;
- do not use it to push, merge, deploy, spend money, alter quests, consume items, or change production state;
- prefer one deterministic read-only command;
- set a clear stop condition;
- stop the loop when the required condition is reached;
- avoid intervals that create noise without decision value.

### Good examples

- poll one GitHub Actions run until it completes;
- check whether a known file has changed during a controlled local test;
- display one bounded health/status command.

### Bad examples

- repeatedly asking Claude to “improve everything”;
- retrying a failing command without understanding the cause;
- running unattended state-changing scripts;
- using the loop as a substitute for CI, scheduling, or monitoring infrastructure.

## 2. Project `/quality-loop` — bounded repair workflow

`/quality-loop` is a project skill for implementation quality:

```text
implement
→ run one deterministic check
→ identify the root cause
→ apply the smallest fix
→ rerun the same check
→ run regression checks
→ request a fresh-context review
```

It is not time-based. It is capped at five iterations and stops when:

- all required checks pass;
- a real manual gate is reached;
- the same root cause repeats twice;
- continuing would require guessed data or unsafe scope expansion.

## Token discipline in loops

Loops can waste tokens when each iteration rereads the same large context. Apply these controls:

1. use a narrow command that emits only decision-relevant output;
2. filter logs locally before they reach the model;
3. delegate high-volume analysis to a read-only subagent;
4. keep one stable model and tool configuration to preserve cache reuse;
5. do not restate the entire task in every iteration;
6. compact with the exact acceptance check when context becomes noisy;
7. record iteration number, command, result, root cause, and change;
8. stop immediately after the condition is satisfied.

## Choosing the mechanism

| Need | Mechanism |
|---|---|
| Recheck a read-only condition over time | official `/loop` |
| Repair code until one test passes | project `/quality-loop` |
| Validate every push or PR | GitHub Actions |
| Run on a fixed external schedule | dedicated scheduler/automation |
| Watch production continuously | monitoring/alerting platform |

## Official references

- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/best-practices
- https://code.claude.com/docs/en/costs
