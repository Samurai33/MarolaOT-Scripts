# Token Efficiency Strategy

## Position on “70% savings”

The repository uses **40–70% reduction** as a stretch target for repetitive, comparable workflows. It is not a universal guarantee.

Official Claude Code guidance supports the mechanisms behind that target:

- prompt caching reduces repeated-prefix cost;
- cache-read tokens are billed at roughly 10% of standard input on API usage;
- skills load procedure bodies on demand;
- path rules load only when matching files are read;
- subagents isolate high-volume exploration;
- hooks/CLI tools can filter logs before the model sees them;
- `/clear` removes stale context;
- `/compact <focus>` preserves only useful history;
- cheaper models can handle bounded tasks;
- disabling unused MCP servers reduces tool overhead.

Total savings depend on model, plan/provider, cache hits, task similarity, context size, output, and correctness.

## Optimization hierarchy

Apply in this order:

1. **Correct task boundary:** one issue objective per session.
2. **Remove stale context:** `/clear` between unrelated tasks.
3. **Reduce always-loaded text:** keep `CLAUDE.md` under 200 lines.
4. **Load on demand:** move procedures to skills.
5. **Load conditionally:** use path-scoped rules.
6. **Isolate volume:** research/logs/reviews in subagents.
7. **Preprocess locally:** grep, parsers, schemas, and hooks.
8. **Reduce tool metadata:** disable unused MCP; prefer CLI.
9. **Route model/effort:** Haiku/Sonnet/Opus by task class.
10. **Preserve cache:** stable directory/model/config/tool set.
11. **Compact deliberately:** before the window becomes noisy.
12. **Measure:** compare same task and acceptance check.

## Cache-friendly behavior

- Keep stable instructions at the beginning.
- Avoid editing `CLAUDE.md`, settings, tools, or model repeatedly during a session.
- Invoke skills when needed; they append task-specific instructions without bloating startup context.
- Request a concise visible status summary instead of compacting when the context is still healthy.
- Keep working in the same directory when cache sharing matters.
- Do not disable prompt caching for normal use.
- On API/provider usage, choose TTL based on measured break patterns and cost.

## Context budget

| Task | Target context | Delegation |
|---|---:|---|
| Lookup | ≤15% | optional Haiku |
| Small doc/config fix | ≤25% | none or one reviewer |
| Research package | ≤35% | researcher |
| Multi-file implementation | ≤50% | researcher + reviewer |
| Release/migration | compact by 65% | architect + security + reviewer |

At 50%, review what is loaded. At 65%, compact with a precise focus or start a clean implementation session.

## Benchmark method

For each benchmark:

1. Define one task, fixture, starting commit, model, and pass/fail check.
2. Run baseline in a fresh session.
3. Record `/usage`, `/context`, cache creation/read, output, duration, and result.
4. Apply one optimization.
5. Run from the same starting state.
6. Calculate input and total-token reduction.
7. Reject optimizations that reduce correctness or reproducibility.
8. Repeat at least three times for noisy tasks.
9. Report median and range, not only the best run.

Formula:

```text
reduction_percent = (baseline_tokens - optimized_tokens)
                    / baseline_tokens * 100
```

## Candidate benchmarks

- audit a new hunt reference;
- create an M2 quest package;
- validate a package after one JSON change;
- diagnose one failed GitHub Actions job;
- review one PR;
- update catalog/changelog after a maturity change.

## Anti-patterns

- giant `CLAUDE.md`;
- importing the entire docs tree;
- keeping all MCP servers enabled;
- pasting full logs instead of filtering;
- one conversation for unrelated issues;
- multiple agents reading the same large files;
- using Opus for inventory work;
- repeated corrections without clearing failed approaches;
- claiming savings from a single non-equivalent run.
