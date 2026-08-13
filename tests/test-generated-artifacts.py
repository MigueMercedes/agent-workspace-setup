from pathlib import Path
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
VALIDATOR = ROOT / "skills/agent-workspace-setup/scripts/validate-generated.py"


def run(root: Path, constraints: Path | None = None) -> subprocess.CompletedProcess[str]:
    command = [sys.executable, str(VALIDATOR), str(root)]
    if constraints:
        command.extend(["--constraints", str(constraints)])
    return subprocess.run(
        command,
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
        ,
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
    agent = root / ".codex/agents/reviewer.toml"
    agent.parent.mkdir(parents=True)
    agent.write_text(
        'name="reviewer"\ndescription="Review"\ndeveloper_instructions="Review"\n'
        'model="runtime-model"\nmodel_reasoning_effort="high"\nsandbox_mode="read-only"\n'
    )
    assert run(root).returncode != 0
    constraints = root / "constraints.json"
    constraints.write_text(
        '{"codex_models":["runtime-model"],"codex_efforts":["high"],'
        '"codex_sandbox_modes":["read-only"]}'
    )
    assert run(root, constraints).returncode == 0

with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    write_shared(root)
    agent = root / ".claude/agents/reviewer.md"
    agent.parent.mkdir(parents=True)
    agent.write_text(
        """---
name: reviewer
description: Reviews completed changes
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

with tempfile.TemporaryDirectory() as temp:
    root = Path(temp)
    write_shared(root)
    agent = root / ".claude/agents/reviewer.md"
    agent.parent.mkdir(parents=True)
    agent.write_text("---\nname: reviewer\ndescription: Review\nmodel: sonnet\neffort: high\n---\nReview.\n")
    assert run(root).returncode != 0
    constraints = root / "constraints.json"
    constraints.write_text('{"claude_models":["sonnet"],"claude_efforts":["high"]}')
    assert run(root, constraints).returncode == 0

print("generated artifact validation: ok")
