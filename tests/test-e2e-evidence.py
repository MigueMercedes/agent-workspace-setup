#!/usr/bin/env python3
from pathlib import Path
import hashlib
import subprocess
import re

ROOT = Path(__file__).resolve().parents[1]
CURRENT = ROOT / "tests/transcripts/current"
VALIDATOR = ROOT / "skills/agent-workspace-setup/scripts/validate-generated.py"


def skill_hash() -> str:
    files = sorted((ROOT / "skills/agent-workspace-setup").rglob("*"))
    records = []
    for path in files:
        if path.is_file():
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            records.append(f"{digest}  {path.relative_to(ROOT)}\n".encode())
    return hashlib.sha256(b"".join(records)).hexdigest()

def sections(text: str) -> dict[str, str]:
    matches = list(re.finditer(r"(?m)^#{2,3} (.+)$", text))
    return {
        match.group(1).strip().lower(): text[match.end(): matches[index + 1].start() if index + 1 < len(matches) else len(text)]
        for index, match in enumerate(matches)
    }


def require_workflow(text: str, case: str) -> None:
    body = text.lower()
    headings = sections(text)
    checks = {
        "orchestrator ownership": r"owns .*(decomposition|requirements).*(routing|review).*(verification|synthesis)",
        "direct-work threshold": r"trivial.*small.*work.*(orchestrator|main agent)",
        "delegation contract": r"inputs.*allowed files.*expected output.*verification.*stop condition",
        "parallelism boundary": r"parallel.*(independent|no dependency).*(non-overlapping|no overlapping|no overlap)",
        "base dependencies": r"(base|parent) commit.*dependenc",
        "semantic routing": r"lowest supported.*balanced.*highest justified supported",
        "escalation": r"escalat.*(fails twice|two)",
        "independent reviews": r"independent specification reviewer.*independent quality reviewer",
        "bounded loop": r"(at most two|maximum of two).*correction pass",
        "whole-change review": r"independent (review of the whole change|whole-change review)",
        "fresh verification": r"fresh verification.*final\s+working tree",
        "unverified reporting": r"report.*(unverified|not verified)",
        "worktree cleanup": r"remove only.*worktree.*(clean|integrated)",
    }
    assert len(headings) >= 3, (case, "workflow sections")
    for name, pattern in checks.items():
        assert re.search(pattern, body, re.DOTALL), (case, name)


for case in ("codex-bootstrap", "claude-adopt"):
    artifacts = CURRENT / case / "artifacts"
    subprocess.run(["python3", str(VALIDATOR), str(artifacts)], check=True)
    agents_text = (artifacts / "AGENTS.md").read_text()
    claude_lines = (artifacts / "CLAUDE.md").read_text().splitlines()
    assert claude_lines and claude_lines[0].strip() == "@AGENTS.md"
    assert all(not line.strip() or line.strip() == "# Claude Code" for line in claude_lines[1:]), case
    require_workflow(agents_text, case)

adopt = CURRENT / "claude-adopt/artifacts"
agents = (adopt / "AGENTS.md").read_text()
baseline = (CURRENT / "claude-adopt/artifacts/AGENTS.baseline.md").read_text()
for rule in (line for line in baseline.splitlines() if line.startswith("- ")):
    assert rule in agents, rule
before = (adopt / "user-notes.before.txt").read_bytes()
after = (adopt / "user-notes.after.txt").read_bytes()
assert hashlib.sha256(before).digest() == hashlib.sha256(after).digest()

for case in ("codex-bootstrap", "claude-adopt"):
    evidence = (CURRENT / case / "evidence.md").read_text()
    for field in ("Fixture", "Invocation", "Session", "Skill hash", "Approval boundary", "Assertions"):
        assert f"## {field}" in evidence, (case, field)
    assert skill_hash() in evidence, (case, "stale skill hash")

print("current E2E evidence: ok")
