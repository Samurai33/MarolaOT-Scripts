---
name: create-hunt-package
description: Create or advance an evidence-driven hunt package while enforcing maturity, safety, licensing, and rollback gates.
disable-model-invocation: true
argument-hint: "[package-slug]"
---

Create or advance hunt package `$ARGUMENTS`.

Before writing executable files:
- verify source-manifest and source-lock;
- confirm license/redistribution;
- identify CaveBot, TargetBot, dependencies, NPCs/refill, supplies, and combat data;
- state the intended M-level transition.

Package independently:
- route/dry-run;
- TargetBot;
- AttackBot;
- HealBot;
- Supplies;
- installer;
- rollback;
- tests/checklist;
- inventory/checksums;
- upstream differences.

Enforce:
- backup before mutation;
- no secret/local account data;
- modules off after install/restore;
- real cooldown/group/element data;
- no M6/M7 claim without operational evidence.

Finish with focused tests, static validation, independent review, catalog/changelog updates, and a PR-ready report.
