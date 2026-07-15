---
name: research-reference
description: Audit official and community references for a hunt, quest, client feature, or vBot workflow without inventing missing data.
disable-model-invocation: true
argument-hint: "[hunt|quest|topic]"
---

Research `$ARGUMENTS` using an isolated read-only research subagent.

Priority:
1. official product/server documentation or source;
2. immutable upstream source code;
3. reputable community repositories/forums;
4. commercial or non-reproducible references only as leads.

Capture:
- URL, owner, repository, branch/tag/commit, path, revision date;
- license and redistribution status;
- components found and missing;
- compatibility signals;
- hashes where practical;
- contradictions and stale data;
- exact blocker for the next maturity level.

Search alternative names, file names, creature/NPC names, coordinates, storages, labels, and copied signatures.

Never:
- invent a route;
- infer a full package from one config;
- copy unlicensed content;
- present a mutable page as immutable evidence.

Update the source registry/manifest/lock and produce a concise evidence report.
