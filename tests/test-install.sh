#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT
source_repo="$sandbox/source"
mkdir -p "$source_repo/skills/agent-workspace-setup"
cp "$repo_root/install.sh" "$source_repo/install.sh"
printf '%s\n' '---' 'name: agent-workspace-setup' \
  'description: Installer fixture.' '---' > \
  "$source_repo/skills/agent-workspace-setup/SKILL.md"
export AGENT_SETUP_CODEX_HOME="$sandbox/codex"
export AGENT_SETUP_CLAUDE_HOME="$sandbox/claude"

dry_output=$(bash "$source_repo/install.sh" --all --dry-run --yes)
grep -Fq "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup" <<<"$dry_output"
grep -Fq "$AGENT_SETUP_CLAUDE_HOME/skills/agent-workspace-setup" <<<"$dry_output"
[[ ! -e "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup" ]]

bash "$source_repo/install.sh" --all --yes
cmp "$source_repo/skills/agent-workspace-setup/SKILL.md" \
  "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup/SKILL.md"
cmp "$source_repo/skills/agent-workspace-setup/SKILL.md" \
  "$AGENT_SETUP_CLAUDE_HOME/skills/agent-workspace-setup/SKILL.md"

printf '%s\n' stale > "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup/stale.txt"
bash "$source_repo/install.sh" --codex --yes
[[ ! -e "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup/stale.txt" ]]
[[ -d "$AGENT_SETUP_CLAUDE_HOME/skills/agent-workspace-setup" ]]
