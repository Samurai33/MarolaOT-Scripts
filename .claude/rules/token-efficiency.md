---
paths:
  - "CLAUDE.md"
  - ".claude/**"
  - "docs/claude/**"
---

# Token and context efficiency

- Optimize correctness per token, not token count alone.
- Keep permanent instructions essential, concise, and non-duplicated.
- Move repeatable procedures to skills and large research to subagents.
- Use path-scoped rules rather than loading every domain instruction at startup.
- Do not add `@imports` to root `CLAUDE.md` as a token-saving technique; imported content is still loaded.
- Keep skills focused and place large examples/reference material in linked supporting docs.
- Prefer local parsers, grep, schemas, and hooks that emit bounded output.
- Do not enable MCP servers that are not needed for the current workflow.
- Preserve prompt-cache stability by avoiding unnecessary model, directory, settings, and tool changes mid-task.
- Require comparable baseline and optimized runs before claiming savings.
- Treat 40–70% as a benchmark target for repetitive workflows, never a universal guarantee.
- Reject any optimization that lowers pass rate, evidence quality, security, or reproducibility.
