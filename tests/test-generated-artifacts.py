from pathlib import Path
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
VALIDATOR = ROOT / "skills/agent-workspace-setup/scripts/validate-generated.py"


def run(root: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(VALIDATOR), str(root)],
        text=True,
        capture_output=True,
    )


def write_shared(root: Path) -> None:
    (root / "AGENTS.md").write_text(
        """# Workflow

The orchestrator owns decomposition and final synthesis. Small tasks stay direct.
Delegated writes record a validated base commit and use isolated worktrees.
Parallel tasks have no shared files or mutable state. Preserve user changes.
Route to the lowest supported, balanced/default, or highest justified supported tier.
Use independent specification and quality review, a bounded fix loop, whole-change review,
fresh verification, and conservative worktree cleanup.
""",
        encoding="utf-8",
    )
    (root / "CLAUDE.md").write_text("@AGENTS.md\n", encoding="utf-8")


with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    write_shared(root)
    result = run(root)
    assert result.returncode == 0, result.stderr

with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    write_shared(root)
    (root / "CLAUDE.md").write_text("# duplicated policy\n", encoding="utf-8")
    result = run(root)
    assert result.returncode != 0

with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    write_shared(root)
    agent = root / ".codex/agents/reviewer.toml"
    agent.parent.mkdir(parents=True)
    agent.write_text(
        'name="reviewer"\ndescription="Review"\ndeveloper_instructions="Check risks"\n'
        'model="verified-model"\nmodel_reasoning_effort="high"\nsandbox_mode="read-only"\n',
        encoding="utf-8",
    )
    result = run(root)
    assert result.returncode == 0, result.stderr
    agent.write_text('name="reviewer"\n', encoding="utf-8")
    result = run(root)
    assert result.returncode != 0

with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    write_shared(root)
    agent = root / ".claude/agents/reviewer.md"
    agent.parent.mkdir(parents=True)
    agent.write_text(
        """---
name: reviewer
description: Reviews completed changes
model: inherit
effort: high
isolation: worktree
---

Review the implementation independently.
""",
        encoding="utf-8",
    )
    result = run(root)
    assert result.returncode == 0, result.stderr
    agent.write_text("---\nname: reviewer\ndescription: Reviews\n---\n", encoding="utf-8")
    result = run(root)
    assert result.returncode != 0

print("generated artifact validation: ok")
