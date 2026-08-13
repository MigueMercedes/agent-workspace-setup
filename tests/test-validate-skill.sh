#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

mkdir -p "$sandbox/tests" "$sandbox/skills"
cp "$repo_root/tests/validate-skill.py" "$sandbox/tests/validate-skill.py"
cp -R "$repo_root/skills/agent-workspace-setup" "$sandbox/skills/"

python3 "$sandbox/tests/validate-skill.py" >/dev/null

rm "$sandbox/skills/agent-workspace-setup/references/workflow.md"
if python3 "$sandbox/tests/validate-skill.py" >/dev/null 2>&1; then
  printf 'validator accepted missing workflow reference\n' >&2
  exit 1
fi
cp -R "$repo_root/skills/agent-workspace-setup/references/workflow.md" \
  "$sandbox/skills/agent-workspace-setup/references/workflow.md"

printf '\n/root/private-token\n' >> \
  "$sandbox/skills/agent-workspace-setup/references/audit.md"

if python3 "$sandbox/tests/validate-skill.py" >/dev/null 2>&1; then
  printf 'validator accepted /root absolute home path\n' >&2
  exit 1
fi
