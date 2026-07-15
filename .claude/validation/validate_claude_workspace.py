#!/usr/bin/env python3
"""Validate the repository-scoped Claude Code workspace."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CLAUDE_DIR = ROOT / ".claude"
ERRORS: list[str] = []


def fail(message: str) -> None:
    ERRORS.append(message)


def read(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except OSError as exc:
        fail(f"{path.relative_to(ROOT)}: cannot read: {exc}")
        return ""


def validate_json(path: Path) -> dict:
    try:
        return json.loads(read(path))
    except json.JSONDecodeError as exc:
        fail(f"{path.relative_to(ROOT)}:{exc.lineno}:{exc.colno}: invalid JSON: {exc.msg}")
        return {}


def frontmatter(path: Path) -> dict[str, str]:
    text = read(path)
    if not text.startswith("---\n"):
        fail(f"{path.relative_to(ROOT)}: missing YAML frontmatter")
        return {}
    end = text.find("\n---\n", 4)
    if end < 0:
        fail(f"{path.relative_to(ROOT)}: unterminated YAML frontmatter")
        return {}
    data: dict[str, str] = {}
    for line in text[4:end].splitlines():
        if not line.strip() or line.startswith((" ", "\t", "-")):
            continue
        if ":" not in line:
            fail(f"{path.relative_to(ROOT)}: malformed frontmatter line: {line}")
            continue
        key, value = line.split(":", 1)
        data[key.strip()] = value.strip()
    return data


def main() -> int:
    required = [
        ROOT / "CLAUDE.md",
        CLAUDE_DIR / "README.md",
        CLAUDE_DIR / "settings.json",
        CLAUDE_DIR / "token-budget.json",
        ROOT / "docs/claude/README.md",
        ROOT / "docs/claude/TOKEN_EFFICIENCY.md",
        ROOT / "docs/claude/SECURITY.md",
    ]
    for path in required:
        if not path.is_file():
            fail(f"missing required file: {path.relative_to(ROOT)}")

    claude_text = read(ROOT / "CLAUDE.md")
    line_count = len(claude_text.splitlines())
    if line_count > 200:
        fail(f"CLAUDE.md has {line_count} lines; maximum is 200")
    if "@" in re.sub(r"`[^`]*`", "", claude_text):
        fail("CLAUDE.md appears to contain an @import; imports increase startup context")

    settings = validate_json(CLAUDE_DIR / "settings.json")
    permissions = settings.get("permissions", {})
    if permissions.get("defaultMode") not in {"default", "manual"}:
        fail("settings.json must use default/manual permission mode")
    if permissions.get("disableBypassPermissionsMode") != "disable":
        fail("settings.json must disable bypassPermissions mode")
    if permissions.get("allow"):
        fail("settings.json must not contain project-wide allow rules")
    deny = set(permissions.get("deny", []))
    if not any("git push --force" in item for item in deny):
        fail("settings.json must deny force push")
    if not any("Read(.env" in item for item in deny):
        fail("settings.json must deny .env reads")

    validate_json(CLAUDE_DIR / "settings.hooks.example.json")
    budget = validate_json(CLAUDE_DIR / "token-budget.json")
    if budget.get("target", {}).get("claimPolicy") != "measured-only":
        fail("token savings claims must be measured-only")

    skill_paths = sorted((CLAUDE_DIR / "skills").glob("*/SKILL.md"))
    expected_skills = {
        "issue-to-pr",
        "research-reference",
        "create-hunt-package",
        "create-quest-package",
        "validate-package",
        "quality-loop",
        "token-audit",
        "review-pr",
    }
    found_skills: set[str] = set()
    for path in skill_paths:
        meta = frontmatter(path)
        name = meta.get("name", "")
        found_skills.add(name)
        if not meta.get("description"):
            fail(f"{path.relative_to(ROOT)}: description is required")
        if meta.get("disable-model-invocation") != "true":
            fail(f"{path.relative_to(ROOT)}: must require explicit user invocation")
    if found_skills != expected_skills:
        fail(f"skill set mismatch: expected {sorted(expected_skills)}, found {sorted(found_skills)}")

    agent_paths = sorted((CLAUDE_DIR / "agents").glob("*.md"))
    expected_agents = {
        "reference-researcher",
        "package-architect",
        "security-reviewer",
        "docs-reviewer",
        "token-auditor",
    }
    found_agents: set[str] = set()
    for path in agent_paths:
        meta = frontmatter(path)
        found_agents.add(meta.get("name", ""))
        if meta.get("permissionMode") != "plan":
            fail(f"{path.relative_to(ROOT)}: reviewer/research agents must use plan mode")
        if "Write" in meta.get("tools", "") or "Edit" in meta.get("tools", ""):
            fail(f"{path.relative_to(ROOT)}: must be read-only")
        if meta.get("model") == "opus":
            fail(f"{path.relative_to(ROOT)}: Opus must not be the default subagent model")
    if found_agents != expected_agents:
        fail(f"agent set mismatch: expected {sorted(expected_agents)}, found {sorted(found_agents)}")

    for path in (CLAUDE_DIR / "rules").glob("*.md"):
        meta = frontmatter(path)
        if "paths" not in meta and "paths:" not in read(path).split("\n---\n", 1)[0]:
            fail(f"{path.relative_to(ROOT)}: rule must be path-scoped")

    hook_example = read(CLAUDE_DIR / "settings.hooks.example.json")
    active_settings = read(CLAUDE_DIR / "settings.json")
    if '"hooks"' in active_settings:
        fail("hooks must remain opt-in and absent from committed settings.json")
    if '"hooks"' not in hook_example:
        fail("hook example must include hooks")

    sensitive_patterns = [
        re.compile(r"(?i)(api[_-]?key|password|access[_-]?token)\s*[:=]\s*[\"'][^\"']{8,}"),
        re.compile(r"-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----"),
    ]
    for path in list(CLAUDE_DIR.rglob("*")) + list((ROOT / "docs/claude").rglob("*")):
        if not path.is_file():
            continue
        text = read(path)
        for pattern in sensitive_patterns:
            if pattern.search(text):
                fail(f"{path.relative_to(ROOT)}: possible secret material")

    if ERRORS:
        for error in ERRORS:
            print(f"::error::{error}")
        print(f"Claude workspace validation: FAILED ({len(ERRORS)} error(s))")
        return 1

    print(f"Claude workspace validation: VALID ({line_count} CLAUDE.md lines, "
          f"{len(skill_paths)} skills, {len(agent_paths)} agents)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
