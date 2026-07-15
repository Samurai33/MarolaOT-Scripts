---
name: quality-loop
description: Iterate implementation, deterministic verification, independent review, and repair until the stated acceptance check passes or a real blocker is proven.
disable-model-invocation: true
argument-hint: "[acceptance-check]"
---

Run a bounded quality loop for `$ARGUMENTS`.

Loop:
1. State one machine-checkable goal and the maximum of 5 iterations.
2. Run the narrowest deterministic check.
3. If it fails, identify the root cause and apply the smallest fix.
4. Re-run the same check.
5. After it passes, run adjacent regression checks.
6. Delegate an adversarial diff review to a fresh reviewer subagent.
7. Fix only correctness, security, scope, licensing, or acceptance gaps.
8. Stop when all required checks pass, a manual gate is reached, or the same root cause repeats twice.

Never:
- hide a failure;
- relax a gate without evidence;
- chase speculative style findings;
- continue an unbounded loop.

Report every iteration, command, result, change, and final stop reason.
