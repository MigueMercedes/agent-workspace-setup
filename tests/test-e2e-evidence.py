#!/usr/bin/env python3
from pathlib import Path
import hashlib
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CURRENT = ROOT / "tests/transcripts/current"
VALIDATOR = ROOT / "skills/agent-workspace-setup/scripts/validate-generated.py"

for case in ("codex-bootstrap", "claude-adopt"):
    artifacts = CURRENT / case / "artifacts"
    subprocess.run(["python3", str(VALIDATOR), str(artifacts)], check=True)
    agents = (artifacts / "AGENTS.md").read_text().lower()
    claude_lines = (artifacts / "CLAUDE.md").read_text().splitlines()
    assert claude_lines and claude_lines[0].strip() == "@AGENTS.md"
    assert "main agent" in agents or "orchestrator" in agents
    for concept in ("parallel", "routing", "review", "verification", "worktree"):
        assert concept in agents, (case, concept)

adopt = CURRENT / "claude-adopt/artifacts"
agents = (adopt / "AGENTS.md").read_text()
assert "Every behavior change requires a failing test observed before implementation." in agents
assert "Never weaken these gates to save time." in agents
before = (adopt / "user-notes.before.txt").read_bytes()
after = (adopt / "user-notes.after.txt").read_bytes()
assert hashlib.sha256(before).digest() == hashlib.sha256(after).digest()

for case in ("codex-bootstrap", "claude-adopt"):
    evidence = (CURRENT / case / "evidence.md").read_text()
    for field in ("Fixture", "Invocation", "Session", "Skill hash", "Approval boundary", "Assertions"):
        assert f"## {field}" in evidence, (case, field)

print("current E2E evidence: ok")
