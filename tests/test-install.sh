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

for unsafe in / //; do
  if AGENT_SETUP_CODEX_HOME="$unsafe" bash "$source_repo/install.sh" --codex --dry-run --yes >/dev/null 2>&1; then
    printf 'accepted unsafe root: %s\n' "$unsafe" >&2
    exit 1
  fi
done
ln -s / "$sandbox/root-link"
if AGENT_SETUP_CODEX_HOME="$sandbox/root-link" bash "$source_repo/install.sh" --codex --dry-run --yes >/dev/null 2>&1; then
  printf 'accepted symlink to root\n' >&2
  exit 1
fi

bin="$sandbox/bin"
mkdir "$bin"
printf '%s\n' '#!/usr/bin/env bash' 'exit 0' > "$bin/codex"
chmod +x "$bin/codex"
detected=$(printf 'n\n' | PATH="$bin:/usr/bin:/bin" bash "$source_repo/install.sh")
grep -Fq "Codex: $AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup" <<<"$detected"
! grep -Fq 'Claude:' <<<"$detected"
grep -Fq 'Install to these destinations? [y/N]' <<<"$detected"

dry_output=$(bash "$source_repo/install.sh" --all --dry-run --yes)
grep -Fq "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup" <<<"$dry_output"
grep -Fq "$AGENT_SETUP_CLAUDE_HOME/skills/agent-workspace-setup" <<<"$dry_output"
[[ ! -e "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup" ]]

bash "$source_repo/install.sh" --all --yes
cmp "$source_repo/skills/agent-workspace-setup/SKILL.md" \
  "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup/SKILL.md"
cmp "$source_repo/skills/agent-workspace-setup/SKILL.md" \
  "$AGENT_SETUP_CLAUDE_HOME/skills/agent-workspace-setup/SKILL.md"

rm -rf "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup"
ln -s "$sandbox/missing-target" \
  "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup"
printf 'n\n' | bash "$source_repo/install.sh" --codex
[[ -L "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup" ]]

rm "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup"
mkdir -p "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup"
printf '%s\n' stale > "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup/stale.txt"
bash "$source_repo/install.sh" --codex --yes
[[ ! -e "$AGENT_SETUP_CODEX_HOME/skills/agent-workspace-setup/stale.txt" ]]
[[ -d "$AGENT_SETUP_CLAUDE_HOME/skills/agent-workspace-setup" ]]
