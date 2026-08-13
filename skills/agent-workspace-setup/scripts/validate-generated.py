#!/usr/bin/env python3
from pathlib import Path
import argparse
import json
import re
import sys
import tomllib


parser = argparse.ArgumentParser()
parser.add_argument("root", nargs="?", default=".")
parser.add_argument("--constraints", type=Path)
args = parser.parse_args()
root = Path(args.root).resolve()
failures: list[str] = []
constraints = {}
if args.constraints:
    try:
        constraints = json.loads(args.constraints.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        failures.append(f"invalid runtime constraints: {error}")


def verified(path: Path, field: str, value: str, constraint_key: str) -> None:
    allowed = constraints.get(constraint_key)
    if not isinstance(allowed, list) or value not in allowed:
        failures.append(
            f"{path.relative_to(root)} {field}={value!r} lacks matching verified runtime constraint"
        )

agents = root / "AGENTS.md"
claude = root / "CLAUDE.md"
if not agents.is_file():
    failures.append("AGENTS.md is missing")
if not claude.is_file():
    failures.append("CLAUDE.md is missing")
elif not re.match(r"\A@AGENTS\.md(?:\n|\Z)", claude.read_text(encoding="utf-8")):
    failures.append("CLAUDE.md must import @AGENTS.md first")

for path in sorted((root / ".codex/agents").glob("*.toml")):
    try:
        data = tomllib.loads(path.read_text(encoding="utf-8"))
    except (OSError, tomllib.TOMLDecodeError) as error:
        failures.append(f"invalid Codex agent {path.relative_to(root)}: {error}")
        continue
    required = {"name", "description", "developer_instructions"}
    missing = sorted(key for key in required if not isinstance(data.get(key), str) or not data[key].strip())
    if missing:
        failures.append(f"Codex agent {path.relative_to(root)} missing: {', '.join(missing)}")
    elif not re.fullmatch(r"[a-z][a-z0-9_-]*", data["name"]):
        failures.append(f"Codex agent {path.relative_to(root)} has invalid name")
    for field, key in (
        ("model", "codex_models"),
        ("model_reasoning_effort", "codex_efforts"),
        ("sandbox_mode", "codex_sandbox_modes"),
    ):
        if field in data:
            if not isinstance(data[field], str) or not data[field].strip():
                failures.append(f"Codex agent {path.relative_to(root)} has invalid {field}")
            else:
                verified(path, field, data[field], key)

for path in sorted((root / ".claude/agents").glob("*.md")):
    text = path.read_text(encoding="utf-8")
    match = re.match(r"\A---\n(.*?)\n---\n(.*)\Z", text, re.DOTALL)
    if not match:
        failures.append(f"Claude agent {path.relative_to(root)} lacks frontmatter and prompt body")
        continue
    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if ":" in line:
            key, value = line.split(":", 1)
            fields[key.strip()] = value.strip()
    missing = [key for key in ("name", "description") if not fields.get(key)]
    if not match.group(2).strip():
        missing.append("prompt body")
    if missing:
        failures.append(f"Claude agent {path.relative_to(root)} missing: {', '.join(missing)}")
        continue
    if not re.fullmatch(r"[a-z][a-z0-9-]*", fields["name"]):
        failures.append(f"Claude agent {path.relative_to(root)} has invalid name")
    for field, key in (
        ("model", "claude_models"),
        ("effort", "claude_efforts"),
        ("isolation", "claude_isolations"),
    ):
        if field in fields:
            verified(path, field, fields[field], key)

if failures:
    for failure in failures:
        print(f"error: {failure}", file=sys.stderr)
    raise SystemExit(1)

print("generated artifacts: ok")
