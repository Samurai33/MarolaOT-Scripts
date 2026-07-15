# Claude Token and Quality Metrics

Use one row per comparable run. Do not store account identifiers or billing secrets.

## Run record

| Field | Value |
|---|---|
| Task ID | |
| Date/time UTC | |
| Starting commit | |
| Model / effort | |
| Claude Code version | |
| Authentication/provider | subscription / API / cloud |
| Fresh session | yes/no |
| Skill(s) | |
| Subagent(s) | |
| MCP servers enabled | |
| CLAUDE.md lines | |
| Context start % | |
| Context end % | |
| Input tokens | |
| Cache creation input tokens | |
| Cache read input tokens | |
| Output/thinking tokens | |
| Duration seconds | |
| Deterministic check | |
| Pass | yes/no |
| Human review defects | |
| Notes | |

## Comparison

| Metric | Baseline | Optimized | Change |
|---|---:|---:|---:|
| Input tokens | | | |
| Total tokens | | | |
| Cache read ratio | | | |
| Duration | | | |
| Pass rate | | | |
| Review defects | | | |

## Decision

- Keep optimization:
- Revert optimization:
- Confidence:
- Repeat count:
- Median reduction:
- Range:
- Correctness impact:
- Next experiment:

A reduction is accepted only when the same acceptance check passes and review quality does not regress.
