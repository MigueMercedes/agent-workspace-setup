from pathlib import Path
import re
import sys


root = Path(__file__).resolve().parents[1]
skill_dir = root / "skills" / "agent-workspace-setup"
skill_file = skill_dir / "SKILL.md"
failures = []

if not skill_file.is_file():
    failures.append("SKILL.md is missing")
    skill_text = ""
else:
    skill_text = skill_file.read_text(encoding="utf-8")

frontmatter_match = re.match(r"\A---\n(.*?)\n---(?:\n|\Z)", skill_text, re.DOTALL)
if not frontmatter_match:
    failures.append("SKILL.md must start with YAML delimiters")
else:
    frontmatter = frontmatter_match.group(1)
    names = re.findall(r"(?m)^name\s*:\s*(.+?)\s*$", frontmatter)
    descriptions = re.findall(r"(?m)^description\s*:\s*(.+?)\s*$", frontmatter)
    if names != ["agent-workspace-setup"]:
        failures.append("frontmatter must contain one agent-workspace-setup name")
    if len(descriptions) != 1 or not descriptions[0]:
        failures.append("frontmatter must contain one description")

required = [
    "references/audit.md",
    "references/agents-md.md",
    "references/claude-md.md",
    "references/workflow.md",
    "references/verification.md",
    "scripts/inspect-project.sh",
]
for relative in required:
    if not (skill_dir / relative).is_file():
        failures.append(f"missing required file: {relative}")

workflow_file = skill_dir / "references" / "workflow.md"
workflow_text = workflow_file.read_text(encoding="utf-8") if workflow_file.is_file() else ""
workflow_contract = {
    "orchestrator ownership": "decomposition, routing, review, verification, and synthesis",
    "delegation threshold": "Keep trivial and small work in the orchestrator",
    "parallelism boundary": "non-overlapping files and mutable state",
    "adaptive routing": "least capable available tier that can reliably complete the task",
    "unverified routing": "persist no exact model identifier or effort value",
    "mechanical routing tier": "cheap/fast",
    "balanced routing tier": "balanced",
    "strongest routing tier": "strongest",
    "worktree isolation": "isolated worktree",
    "user-change preservation": "Preserve user changes",
    "fresh implementer": "fresh implementer for each delegated",
    "specification review": "independent specification reviewer",
    "quality review": "independent quality reviewer",
    "bounded escalation": "bounded fix loop",
    "whole-change review": "whole-change review",
    "fresh verification": "fresh verification",
    "safe cleanup": "owned, completed, and integrated worktrees",
    "Claude target": ".claude/agents/*.md",
    "Codex target": ".codex/agents/*.toml",
}
for label, phrase in workflow_contract.items():
    if phrase not in workflow_text:
        failures.append(f"workflow contract missing {label}: {phrase}")

proposal_contract = {
    "Workflow field": "- **Workflow:**",
    "Orchestrator field": "- **Orchestrator:**",
    "Delegation field": "- **Delegation:**",
    "Routing field": "- **Routing:**",
    "Task loop field": "- **Task loop:**",
    "Completion field": "- **Completion:**",
    "Runtime targets field": "- **Runtime targets:**",
    "routing matrix": "three-row cheap/fast, balanced, and strongest",
    "Codex runtime target": ".codex/agents/*.toml",
    "Claude runtime target": ".claude/agents/*.md",
}
for label, phrase in proposal_contract.items():
    if phrase not in skill_text:
        failures.append(f"proposal contract missing {label}: {phrase}")

for raw_target in re.findall(r"!?\[[^\]]*\]\(([^)]+)\)", skill_text):
    target_text = raw_target.strip().strip("<>").split("#", 1)[0]
    if not target_text or re.match(r"^[A-Za-z][A-Za-z0-9+.-]*:", target_text):
        continue
    target = (skill_dir / target_text).resolve()
    try:
        target.relative_to(skill_dir.resolve())
    except ValueError:
        failures.append(f"local link escapes skill directory: {raw_target}")
        continue
    if not target.exists():
        failures.append(f"broken local link: {raw_target}")

banned = re.compile(
    r"(?i)\b(?:tbd|todo|placeholder)\b|"
    r"(?:/root(?:/|\b)|/home/[^/\s]+|/Users/[^/\s]+|[A-Z]:\\Users\\[^\\\s]+)"
)
for path in sorted(candidate for candidate in skill_dir.rglob("*") if candidate.is_file()):
    if banned.search(path.read_text(encoding="utf-8")):
        failures.append(f"banned text in {path.relative_to(root)}")

if failures:
    for failure in failures:
        print(f"error: {failure}", file=sys.stderr)
    sys.exit(1)

print("skill structure: ok")
