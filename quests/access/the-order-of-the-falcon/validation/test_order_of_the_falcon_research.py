#!/usr/bin/env python3
"""Static safety gate for the M2 Order of the Falcon research package."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

PACKAGE_DIR = Path(__file__).resolve().parents[1]


class ValidationError(RuntimeError):
    """Raised when the research package violates an M2 invariant."""


def load_json(relative_path: str) -> dict[str, Any]:
    path = PACKAGE_DIR / relative_path
    if not path.is_file():
        raise ValidationError(f"Missing required file: {relative_path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValidationError(f"Invalid JSON in {relative_path}: {exc}") from exc


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def validate_manifest(manifest: dict[str, Any]) -> None:
    package = manifest.get("package", {})
    require(package.get("slug") == "the-order-of-the-falcon", "Unexpected package slug")
    require(package.get("type") == "quest", "Package type must be quest")
    require(package.get("status") == "reference-audited", "Package must remain reference-audited")
    require(manifest.get("maturity") == "M2", "Package must remain M2")

    components = manifest.get("components", {})
    for name in ("cavebot", "targetbot", "attackbot", "healbot", "supplies", "refill", "rollback"):
        require(components.get(name, {}).get("status") == "missing", f"{name} must remain missing in M2")

    checkpoints = manifest.get("safety", {}).get("manualCheckpoints", [])
    checkpoint_text = " ".join(str(value).lower() for value in checkpoints)
    for required in ("ritual", "miniboss", "oberon"):
        require(required in checkpoint_text, f"Missing manual checkpoint for {required}")


def validate_source_lock(source_lock: dict[str, Any]) -> None:
    require(source_lock.get("package") == "the-order-of-the-falcon", "Source lock package mismatch")
    require(source_lock.get("readyRouteSearch", {}).get("status") == "not-found", "Ready route status must be not-found")

    prohibited = " ".join(source_lock.get("prohibitedUntilVerified", [])).lower()
    for required in ("ritual", "miniboss", "oberon"):
        require(required in prohibited, f"Missing prohibition for {required}")

    canary_sources = [source for source in source_lock.get("sources", []) if source.get("name") == "OpenTibiaBR Canary"]
    require(len(canary_sources) == 1, "Exactly one Canary source lock is required")
    canary = canary_sources[0]
    require(canary.get("commit") == "a879c9312e34381e8eedf397b8ed44510698b689", "Unexpected Canary commit")
    require(len(canary.get("files", [])) == 5, "Five audited Canary files are required")


def validate_quest_data(data: dict[str, Any]) -> None:
    quest = data.get("quest", {})
    require(quest.get("missionId") == 10464, "Unexpected mission id")
    require(quest.get("minimumLevel") == 250, "Unexpected minimum level")
    require(quest.get("recommendedPartySize") == 5, "Unexpected party size")

    progression = data.get("bossProgression", [])
    require(len(progression) == 6, "Boss progression must contain six encounters")
    expected = [
        (1, "Grand Commander Soeren", 1),
        (2, "Preceptor Lazare", 2),
        (3, "Grand Chaplain Gaunder", 3),
        (4, "Grand Canon Dominus", 4),
        (5, "Dazed Leaf Golem", 5),
        (6, "Grand Master Oberon", 6),
    ]
    actual = [(entry.get("order"), entry.get("name"), entry.get("storageValue")) for entry in progression]
    require(actual == expected, "Boss progression order or storage values changed")
    require(all(entry.get("manual") is True for entry in progression), "Every boss must remain manual")

    oberon = data.get("oberon", {})
    require(oberon.get("manual") is True, "Oberon must remain manual")
    require(oberon.get("debateAutomationProhibited") is True, "Oberon debate automation must remain prohibited")
    require(oberon.get("maximumPlayers") == 5, "Unexpected Oberon player limit")
    require(oberon.get("cooldownSeconds") == 72000, "Unexpected Oberon cooldown")

    stages = data.get("stages", [])
    require(any(stage.get("id") == "chalk-preparation-and-ritual" and stage.get("automation") == "manual-only" for stage in stages), "Ritual must be manual-only")
    require(any(stage.get("id") == "grand-master-oberon" and stage.get("automation") == "manual-only" for stage in stages), "Oberon stage must be manual-only")


def validate_no_executable_route() -> None:
    forbidden_suffixes = {".cfg", ".lua", ".otml", ".exe", ".bat", ".cmd"}
    forbidden_directories = {"install", "rollback"}

    for path in PACKAGE_DIR.rglob("*"):
        if path.is_dir() and path.name.lower() in forbidden_directories:
            raise ValidationError(f"Forbidden M2 directory present: {path.relative_to(PACKAGE_DIR)}")
        if path.is_file() and path.suffix.lower() in forbidden_suffixes:
            raise ValidationError(f"Executable route/content is forbidden in M2: {path.relative_to(PACKAGE_DIR)}")


def main() -> int:
    try:
        manifest = load_json("source-manifest.json")
        source_lock = load_json("source-lock.json")
        quest_data = load_json("evidence/quest-data.json")

        validate_manifest(manifest)
        validate_source_lock(source_lock)
        validate_quest_data(quest_data)
        validate_no_executable_route()
    except ValidationError as exc:
        print(f"::error::{exc}")
        return 1

    print("Order of the Falcon M2 research package passed all safety gates.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
