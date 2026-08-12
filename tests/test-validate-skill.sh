#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

mkdir -p "$sandbox/tests" "$sandbox/skills"
cp "$repo_root/tests/validate-skill.py" "$sandbox/tests/validate-skill.py"
cp -R "$repo_root/skills/agent-workspace-setup" "$sandbox/skills/"

python3 "$sandbox/tests/validate-skill.py" >/dev/null

workflow="$sandbox/skills/agent-workspace-setup/references/workflow.md"
contract_phrases=(
  'decomposition, routing, review, verification, and synthesis'
  'Keep trivial and small work in the orchestrator'
  'non-overlapping files and mutable state'
  'least capable available tier that can reliably complete the task'
  'persist no exact model identifier or effort value'
  'cheap/fast'
  'balanced'
  'strongest'
  'isolated worktree'
  'Preserve user changes'
  'fresh implementer for each delegated'
  'independent specification reviewer'
  'independent quality reviewer'
  'bounded fix loop'
  'whole-change review'
  'fresh verification'
  'owned, completed, and integrated worktrees'
  '.claude/agents/*.md'
  '.codex/agents/*.toml'
)
for phrase in "${contract_phrases[@]}"; do
  cp "$workflow" "$workflow.saved"
  python3 - "$workflow" "$phrase" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
phrase = sys.argv[2]
text = path.read_text(encoding="utf-8")
if phrase not in text:
    raise SystemExit(f"fixture phrase missing: {phrase}")
path.write_text(text.replace(phrase, "removed-contract-component"), encoding="utf-8")
PY
  if python3 "$sandbox/tests/validate-skill.py" >/dev/null 2>&1; then
    printf 'validator accepted missing workflow component: %s\n' "$phrase" >&2
    exit 1
  fi
  mv "$workflow.saved" "$workflow"
done

skill="$sandbox/skills/agent-workspace-setup/SKILL.md"
proposal_phrases=(
  '- **Workflow:**'
  '- **Orchestrator:**'
  '- **Delegation:**'
  '- **Routing:**'
  '- **Task loop:**'
  '- **Completion:**'
  '- **Runtime targets:**'
  'three-row cheap/fast, balanced, and strongest'
  '.codex/agents/*.toml'
  '.claude/agents/*.md'
)
for phrase in "${proposal_phrases[@]}"; do
  cp "$skill" "$skill.saved"
  python3 - "$skill" "$phrase" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
phrase = sys.argv[2]
text = path.read_text(encoding="utf-8")
if phrase not in text:
    raise SystemExit(f"fixture phrase missing: {phrase}")
path.write_text(text.replace(phrase, "removed-proposal-component"), encoding="utf-8")
PY
  if python3 "$sandbox/tests/validate-skill.py" >/dev/null 2>&1; then
    printf 'validator accepted missing proposal component: %s\n' "$phrase" >&2
    exit 1
  fi
  mv "$skill.saved" "$skill"
done

printf '\n/root/private-token\n' >> \
  "$sandbox/skills/agent-workspace-setup/references/audit.md"

if python3 "$sandbox/tests/validate-skill.py" >/dev/null 2>&1; then
  printf 'validator accepted /root absolute home path\n' >&2
  exit 1
fi
