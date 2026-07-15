#!/usr/bin/env python3
"""Validate versioned vBot 4.8 configuration files and schema fixtures."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from collections.abc import Callable, Iterable
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator
from jsonschema.exceptions import SchemaError


ROOT = Path(__file__).resolve().parents[2]
SCHEMA_ROOT = ROOT / "schemas" / "vbot-4.8"

SCHEMA_PATHS: dict[str, Path] = {
    "attackbot": SCHEMA_ROOT / "attackbot.schema.json",
    "healbot": SCHEMA_ROOT / "healbot.schema.json",
    "supplies": SCHEMA_ROOT / "supplies.schema.json",
    "targetbot": SCHEMA_ROOT / "targetbot.schema.json",
}

POSITIVE_CASES: dict[str, tuple[Path, ...]] = {
    "attackbot": (ROOT / "configs/vbot-4.8/examples/AttackBot.example.json",),
    "healbot": (ROOT / "configs/vbot-4.8/examples/HealBot.example.json",),
    "supplies": (ROOT / "configs/vbot-4.8/examples/Supplies.example.json",),
    "targetbot": (ROOT / "configs/vbot-4.8/examples/TargetBot.example.json",),
}

INVALID_FIXTURES: dict[str, Path] = {
    "attackbot": ROOT / "tests/fixtures/vbot-schemas/invalid/attackbot.invalid.json",
    "healbot": ROOT / "tests/fixtures/vbot-schemas/invalid/healbot.invalid.json",
    "supplies": ROOT / "tests/fixtures/vbot-schemas/invalid/supplies.invalid.json",
    "targetbot": ROOT / "tests/fixtures/vbot-schemas/invalid/targetbot.invalid.json",
}


@dataclass(frozen=True)
class ValidationIssue:
    path: Path
    location: str
    message: str


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def display_path(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return path.as_posix()


def emit_issue(issue: ValidationIssue) -> None:
    relative = display_path(issue.path)
    message = issue.message.replace("\r", " ").replace("\n", " ")
    location = f" [{issue.location}]" if issue.location else ""

    if os.getenv("GITHUB_ACTIONS") == "true":
        print(f"::error file={relative}::{message}{location}")
    else:
        print(f"ERROR {relative}{location}: {message}")


def schema_location(error: Any) -> str:
    return ".".join(str(part) for part in error.absolute_path) or "<root>"


def validate_schema_document(schema_path: Path) -> Draft202012Validator:
    schema = load_json(schema_path)
    Draft202012Validator.check_schema(schema)
    return Draft202012Validator(schema)


def validate_with_schema(
    path: Path,
    validator: Draft202012Validator,
) -> list[ValidationIssue]:
    try:
        document = load_json(path)
    except (OSError, json.JSONDecodeError) as exc:
        return [ValidationIssue(path, "<root>", f"Unable to read JSON: {exc}")]

    return [
        ValidationIssue(path, schema_location(error), error.message)
        for error in sorted(
            validator.iter_errors(document),
            key=lambda item: tuple(str(part) for part in item.absolute_path),
        )
    ]


def number(value: Any) -> float:
    if isinstance(value, bool):
        raise ValueError("boolean is not a numeric supply value")
    return float(value)


def semantic_attackbot(path: Path, document: Any) -> list[ValidationIssue]:
    issues: list[ValidationIssue] = []

    for profile_index, profile in enumerate(document.get("AttackBot", [])):
        if profile.get("enabled") is not False:
            issues.append(
                ValidationIssue(
                    path,
                    f"AttackBot.{profile_index}.enabled",
                    "Versioned AttackBot profiles must be disabled by default.",
                )
            )

        for entry_index, entry in enumerate(profile.get("attackTable", [])):
            minimum = entry.get("minHp")
            maximum = entry.get("maxHp")
            if isinstance(minimum, int) and isinstance(maximum, int) and minimum > maximum:
                issues.append(
                    ValidationIssue(
                        path,
                        f"AttackBot.{profile_index}.attackTable.{entry_index}",
                        "minHp cannot be greater than maxHp.",
                    )
                )

    return issues


def validate_unique_indexes(
    path: Path,
    entries: Iterable[dict[str, Any]],
    location: str,
) -> list[ValidationIssue]:
    indexes = [entry.get("index") for entry in entries]
    if len(indexes) == len(set(indexes)):
        return []

    return [ValidationIssue(path, location, "Entry indexes must be unique within the table.")]


def semantic_healbot(path: Path, document: Any) -> list[ValidationIssue]:
    issues: list[ValidationIssue] = []

    for profile_index, profile in enumerate(document.get("healbot", [])):
        if profile.get("enabled") is not False:
            issues.append(
                ValidationIssue(
                    path,
                    f"healbot.{profile_index}.enabled",
                    "Versioned HealBot profiles must be disabled by default.",
                )
            )

        issues.extend(
            validate_unique_indexes(
                path,
                profile.get("spellTable", []),
                f"healbot.{profile_index}.spellTable",
            )
        )
        issues.extend(
            validate_unique_indexes(
                path,
                profile.get("itemTable", []),
                f"healbot.{profile_index}.itemTable",
            )
        )

    return issues


def semantic_supplies(path: Path, document: Any) -> list[ValidationIssue]:
    issues: list[ValidationIssue] = []
    supplies = document.get("supplies", {})
    current = supplies.get("currentProfile")

    if isinstance(current, str) and current not in supplies:
        issues.append(
            ValidationIssue(
                path,
                "supplies.currentProfile",
                f"Selected profile '{current}' does not exist.",
            )
        )

    for profile_name, profile in supplies.items():
        if profile_name == "currentProfile" or not isinstance(profile, dict):
            continue

        for item_id, item_range in profile.get("items", {}).items():
            try:
                minimum = number(item_range.get("min"))
                maximum = number(item_range.get("max"))
            except (TypeError, ValueError):
                continue

            if minimum > maximum:
                issues.append(
                    ValidationIssue(
                        path,
                        f"supplies.{profile_name}.items.{item_id}",
                        "Supply minimum cannot be greater than maximum.",
                    )
                )

    return issues


def semantic_targetbot(path: Path, document: Any) -> list[ValidationIssue]:
    issues: list[ValidationIssue] = []
    names: set[str] = set()

    for index, target in enumerate(document.get("targeting", [])):
        name = str(target.get("name", "")).strip().casefold()
        if name in names:
            issues.append(
                ValidationIssue(
                    path,
                    f"targeting.{index}.name",
                    "Target names must be unique within one configuration.",
                )
            )
        names.add(name)

        lure_min = target.get("lureMin")
        lure_max = target.get("lureMax")
        if isinstance(lure_min, int) and isinstance(lure_max, int) and lure_min > lure_max:
            issues.append(
                ValidationIssue(
                    path,
                    f"targeting.{index}",
                    "lureMin cannot be greater than lureMax.",
                )
            )

        regex = target.get("regex")
        if isinstance(regex, str):
            try:
                re.compile(regex)
            except re.error as exc:
                issues.append(
                    ValidationIssue(
                        path,
                        f"targeting.{index}.regex",
                        f"Regex is not accepted by the validation engine: {exc}",
                    )
                )

    return issues


SEMANTIC_VALIDATORS: dict[str, Callable[[Path, Any], list[ValidationIssue]]] = {
    "attackbot": semantic_attackbot,
    "healbot": semantic_healbot,
    "supplies": semantic_supplies,
    "targetbot": semantic_targetbot,
}


def discover_versioned_files() -> dict[str, set[Path]]:
    discovered = {key: set(paths) for key, paths in POSITIVE_CASES.items()}

    patterns = {
        "attackbot": ("**/AttackBot.json", "**/AttackBot.example.json"),
        "healbot": ("**/HealBot.json", "**/HealBot.example.json"),
        "supplies": ("**/Supplies.json", "**/Supplies.example.json"),
        "targetbot": ("**/targetbot_configs/*.json", "**/TargetBot.example.json"),
    }

    ignored_parts = {
        ".git",
        "backup",
        "backups",
        "quarantine",
        "node_modules",
        "invalid",
    }

    for schema_name, globs in patterns.items():
        for pattern in globs:
            for path in ROOT.glob(pattern):
                if any(part.casefold() in ignored_parts for part in path.parts):
                    continue
                discovered[schema_name].add(path)

    return discovered


def validate_document(
    schema_name: str,
    path: Path,
    validator: Draft202012Validator,
) -> list[ValidationIssue]:
    issues = validate_with_schema(path, validator)
    if issues:
        return issues

    document = load_json(path)
    issues.extend(SEMANTIC_VALIDATORS[schema_name](path, document))
    return issues


def run() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--skip-invalid-fixtures",
        action="store_true",
        help="Do not verify that negative fixtures are rejected.",
    )
    args = parser.parse_args()

    validators: dict[str, Draft202012Validator] = {}
    issues: list[ValidationIssue] = []

    for schema_name, schema_path in SCHEMA_PATHS.items():
        try:
            validators[schema_name] = validate_schema_document(schema_path)
        except (OSError, json.JSONDecodeError, SchemaError) as exc:
            issues.append(
                ValidationIssue(schema_path, "<schema>", f"Invalid JSON Schema: {exc}")
            )

    if issues:
        for issue in issues:
            emit_issue(issue)
        return 1

    discovered = discover_versioned_files()
    validated_count = 0

    for schema_name, paths in discovered.items():
        for path in sorted(paths):
            file_issues = validate_document(schema_name, path, validators[schema_name])
            issues.extend(file_issues)
            validated_count += 1
            if not file_issues:
                print(f"VALID {schema_name}: {display_path(path)}")

    if not args.skip_invalid_fixtures:
        for schema_name, fixture_path in INVALID_FIXTURES.items():
            fixture_issues = validate_document(
                schema_name,
                fixture_path,
                validators[schema_name],
            )
            if not fixture_issues:
                issues.append(
                    ValidationIssue(
                        fixture_path,
                        "<fixture>",
                        "Negative fixture was unexpectedly accepted.",
                    )
                )
            else:
                print(
                    f"EXPECTED INVALID {schema_name}: "
                    f"{display_path(fixture_path)} ({len(fixture_issues)} issue(s))"
                )

    if issues:
        print(f"\nValidation failed with {len(issues)} issue(s).")
        for issue in issues:
            emit_issue(issue)
        return 1

    print(f"\nValidated {validated_count} versioned vBot configuration file(s).")
    print("All negative fixtures were rejected as expected.")
    return 0


if __name__ == "__main__":
    sys.exit(run())
