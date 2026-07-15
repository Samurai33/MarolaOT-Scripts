---
name: create-quest-package
description: Create or advance an assisted quest package split into reversible navigation segments and mandatory manual checkpoints.
disable-model-invocation: true
argument-hint: "[quest-slug]"
---

Create or advance quest package `$ARGUMENTS`.

1. Audit editorial sequence and primary server progression data.
2. Record mission IDs, storages, NPCs, items, positions, actions, gates, and source revisions.
3. Mark every external coordinate provisional until confirmed in MarolaOT.
4. Split the quest into short segments:
   `safe origin → navigation → visible manual checkpoint → safe return`.
5. Keep dialogue, item use, bosses, levers, arenas, prisons, multiplayer gates, choices, and rewards manual.
6. Keep M0–M2 non-executable.
7. For M3+, require validated/adjusted coordinates, recovery paths, dry-run evidence, and parser approval.
8. Update checklist, evidence JSON, source files, catalog, changelog, tests, and PR.

Never create one unattended script for an entire long quest.
