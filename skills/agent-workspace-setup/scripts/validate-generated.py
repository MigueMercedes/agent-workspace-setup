#!/usr/bin/env python3
from pathlib import Path
import re
import sys
import tomllib


root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
failures: list[str] = []

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
    required = {
        "name",
        "description",
        "developer_instructions",
        "model",
        "model_reasoning_effort",
        "sandbox_mode",
    }
    missing = sorted(key for key in required if not isinstance(data.get(key), str) or not data[key].strip())
    if missing:
        failures.append(f"Codex agent {path.relative_to(root)} missing: {', '.join(missing)}")
    elif not re.fullmatch(r"[a-z][a-z0-9_-]*", data["name"]):
        failures.append(f"Codex agent {path.relative_to(root)} has invalid name")
    if data.get("sandbox_mode") not in {"read-only", "workspace-write", "danger-full-access"}:
        failures.append(f"Codex agent {path.relative_to(root)} has invalid sandbox_mode")

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
    missing = [key for key in ("name", "description", "model", "effort", "isolation") if not fields.get(key)]
    if not match.group(2).strip():
        missing.append("prompt body")
    if missing:
        failures.append(f"Claude agent {path.relative_to(root)} missing: {', '.join(missing)}")
        continue
    if not re.fullmatch(r"[a-z][a-z0-9-]*", fields["name"]):
        failures.append(f"Claude agent {path.relative_to(root)} has invalid name")
    if fields["effort"] not in {"low", "medium", "high", "xhigh", "max"}:
        failures.append(f"Claude agent {path.relative_to(root)} has invalid effort")
    if fields["isolation"] != "worktree":
        failures.append(f"Claude agent {path.relative_to(root)} has invalid isolation")

if failures:
    for failure in failures:
        print(f"error: {failure}", file=sys.stderr)
    raise SystemExit(1)

print("generated artifacts: ok")
