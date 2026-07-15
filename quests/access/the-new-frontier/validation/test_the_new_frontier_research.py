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


def validate_coordinates(coordinates: dict[str, Any]) -> None:
    require(
        coordinates["datasetStatus"] == "provisional-reference",
        "Coordinate dataset must remain provisional-reference in M2.",
    )
    require(
        coordinates["source"]["url"]
        == "https://www.tibiawiki.com.br/wiki/The_New_Frontier_Quest",
        "Coordinate dataset must point to the audited TibiaWiki page.",
    )
    require(
        coordinates["validationPolicy"]["coordinateIsNotWaypoint"] is True,
        "The dataset must explicitly state that a coordinate is not a waypoint.",
    )
    require(
        coordinates["validationPolicy"]["manualActionsRemainManual"] is True,
        "Manual quest actions must remain manual.",
    )

    points = coordinates["points"]
    require(len(points) == 26, "The audited TibiaWiki dataset must contain 26 points.")

    ids = [point["id"] for point in points]
    require(len(ids) == len(set(ids)), "Coordinate point IDs must be unique.")

    for point in points:
        require(
            point["validationStatus"] == "pending-marolaot-validation",
            f"Coordinate {point['id']} must remain pending MarolaOT validation.",
        )
        require(
            isinstance(point["mission"], int) and 0 <= point["mission"] <= 10,
            f"Coordinate {point['id']} has an invalid mission number.",
        )

        position = point["position"]
        require(
            set(position) == {"x", "y", "z"},
            f"Coordinate {point['id']} must contain only x, y and z.",
        )
        require(
            all(isinstance(position[axis], int) for axis in ("x", "y", "z")),
            f"Coordinate {point['id']} must use integer axes.",
        )
        require(
            position["x"] > 0 and position["y"] > 0 and position["z"] >= 0,
            f"Coordinate {point['id']} contains an invalid axis value.",
        )

    required_ids = {
        "m01-farmine-right-elevator",
        "m01-mountain-passage-trigger",
        "m02-melfar",
        "m02-tree-01",
        "m02-tree-02",
        "m02-tree-03",
        "m03-mountain-vines",
        "m04-farmine-left-elevator",
        "m06-mooh-tah-arena-entrance",
        "m07-sealed-doors",
        "m09-chrak",
    }
    require(
        required_ids.issubset(ids),
        "Coordinate dataset is missing one or more critical audited points.",
    )

    mission_five_ids = {point["id"] for point in points if point["mission"] == 5}
    require(
        mission_five_ids
        == {
            "m05-angus",
            "m05-humgolf",
            "m05-king-tibianus",
            "m05-leeland",
            "m05-telas",
            "m05-wyrdin",
        },
        "Mission 5 must contain exactly the six audited representative coordinates.",
    )

    require(
        len(coordinates["unresolvedReferencePoints"]) == 6,
        "Unresolved editorial points must remain documented rather than invented.",
    )


def main() -> int:
    manifest = load_json("source-manifest.json")
    source_lock = load_json("source-lock.json")
    evidence = load_json("evidence/quest-data.json")
    coordinates = load_json("evidence/tibiawiki-coordinates.json")

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

    validate_coordinates(coordinates)

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
        "coordinate validation": ("coordenada", "coordinate"),
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
