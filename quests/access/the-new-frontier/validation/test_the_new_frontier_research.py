#!/usr/bin/env python3
"""Static safety gate for The New Frontier M2 research package."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

PACKAGE_ROOT = Path(__file__).resolve().parents[1]


def load_json(relative_path: str) -> dict[str, Any]:
    path = PACKAGE_ROOT / relative_path
    try:
        with path.open(encoding="utf-8") as handle:
            return json.load(handle)
    except (OSError, json.JSONDecodeError) as exc:
        raise AssertionError(f"Unable to read {relative_path}: {exc}") from exc


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> int:
    manifest = load_json("source-manifest.json")
    source_lock = load_json("source-lock.json")
    evidence = load_json("evidence/quest-data.json")

    require(manifest["maturity"] == "M2", "Package must remain at maturity M2.")
    require(
        manifest["package"]["status"] == "reference-audited",
        "Package status must be reference-audited.",
    )
    require(
        manifest["components"]["cavebot"]["status"] == "missing",
        "CaveBot must remain missing while the package is M2.",
    )
    require(
        manifest["components"]["rollback"]["status"] == "missing",
        "Rollback must remain missing until executable content exists.",
    )

    missions = evidence["missions"]
    require(len(missions) == 10, "Exactly ten main missions must be documented.")
    require(
        [mission["number"] for mission in missions] == list(range(1, 11)),
        "Mission numbers must be sequential from 1 to 10.",
    )
    require(
        [mission["missionId"] for mission in missions]
        == [10409, 10410, 10411, 10412, 10413, 10420, 10421, 10422, 10423, 10424],
        "Main mission IDs do not match the audited Canary catalog.",
    )

    mission_five = missions[4]
    require(
        [entry["missionId"] for entry in mission_five["subMissions"]]
        == [10414, 10415, 10416, 10417, 10418, 10419],
        "Mission 5 sub-mission IDs must cover all six representatives.",
    )
    require(
        all(entry["strategy"] == "manual" for entry in mission_five["subMissions"]),
        "All Mission 5 persuasion dialogues must remain manual.",
    )

    mechanics = evidence["verifiedMechanics"]
    require(mechanics["beaverBait"]["itemId"] == 9843, "Unexpected beaver bait item ID.")
    require(
        len(mechanics["beaverBait"]["treePositions"]) == 3,
        "The three beaver bait trees must be documented.",
    )
    require(mechanics["beaverBait"]["manualOnly"] is True, "Beaver bait must remain manual.")
    require(
        mechanics["shardOfCorruption"]["manualOnly"] is True,
        "Shard of Corruption must remain manual.",
    )
    require(
        mechanics["prisonSecretDoor"]["manualOnly"] is True,
        "The prison secret door must remain manual.",
    )

    arena = mechanics["isleOfStrifeArena"]
    require(arena["players"] == 2, "The Isle of Strife arena requires two players.")
    require(arena["actionId"] == 30003, "Unexpected Isle of Strife action ID.")
    require(arena["timeoutMinutes"] == 30, "Unexpected arena timeout.")
    require(arena["waveIntervalSeconds"] == 90, "Unexpected boss wave interval.")
    require(len(arena["waves"]) == 7, "The arena must document seven waves.")
    require(arena["manualOnly"] is True, "The arena must remain manual.")

    search_result = source_lock["searchResult"]
    require(
        search_result["readyPublicCaveBotFound"] is False,
        "M2 assumes no reproducible public CaveBot was found.",
    )
    require(
        search_result["completeLicensedPackageFound"] is False,
        "M2 assumes no complete licensed package was found.",
    )

    forbidden_suffixes = {".cfg", ".lua", ".ps1", ".bat", ".cmd", ".exe"}
    forbidden_directories = {"install", "rollback", "cavebot", "targetbot"}

    for path in PACKAGE_ROOT.rglob("*"):
        relative = path.relative_to(PACKAGE_ROOT)
        if path.is_dir() and path.name.lower() in forbidden_directories:
            raise AssertionError(f"Forbidden M2 directory found: {relative}")
        if path.is_file() and path.suffix.lower() in forbidden_suffixes:
            raise AssertionError(f"Forbidden executable/route file found in M2: {relative}")

    route_entries = [
        path.relative_to(PACKAGE_ROOT / "route")
        for path in (PACKAGE_ROOT / "route").rglob("*")
        if path.is_file()
    ]
    require(route_entries == [Path("README.md")], "Route directory must contain only README.md in M2.")

    required_manual_concepts = {
        "beaver bait": ("beaver",),
        "Shard of Corruption": ("shard",),
        "persuasion dialogues": ("persuas",),
        "Mooh'Tah arena": ("mooh",),
        "prison": ("pris", "prison"),
        "two-player requirement": ("dois", "two", "outro jogador"),
        "arena": ("arena",),
    }
    combined_checkpoints = " ".join(manifest["safety"]["manualCheckpoints"]).lower()
    for concept, alternatives in required_manual_concepts.items():
        require(
            any(token in combined_checkpoints for token in alternatives),
            f"Missing manual checkpoint coverage: {concept}",
        )

    print("The New Frontier M2 research package: VALID")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as exc:
        print(f"::error::{exc}")
        raise SystemExit(1) from exc
