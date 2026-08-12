#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source_dir="$repo_root/skills/agent-workspace-setup"
codex_root=${AGENT_SETUP_CODEX_HOME:-${CODEX_HOME:-$HOME/.codex}}
claude_root=${AGENT_SETUP_CLAUDE_HOME:-$HOME/.claude}

runtime=
dry_run=false
assume_yes=false
while (($#)); do
  case "$1" in
    --codex|--claude|--all)
      [[ -z "$runtime" ]] || { printf 'error: choose one runtime selector\n' >&2; exit 2; }
      runtime=$1
      ;;
    --dry-run) dry_run=true ;;
    --yes) assume_yes=true ;;
    -h|--help)
      printf 'Usage: %s [--codex|--claude|--all] [--dry-run] [--yes]\n' "$0"
      exit 0
      ;;
    *) printf 'error: unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
  shift
done
[[ -f "$source_dir/SKILL.md" ]] || { printf 'error: source skill missing\n' >&2; exit 2; }

if [[ -z "$runtime" ]]; then
  has_codex=false
  has_claude=false
  command -v codex >/dev/null 2>&1 && has_codex=true
  command -v claude >/dev/null 2>&1 && has_claude=true
  if "$has_codex" && "$has_claude"; then runtime=--all
  elif "$has_codex"; then runtime=--codex
  elif "$has_claude"; then runtime=--claude
  else printf 'error: no supported runtime detected\n' >&2; exit 2
  fi
fi

canonical_root() {
  python3 - "$1" <<'PY'
import os
import sys
root = os.path.realpath(os.path.abspath(os.path.expanduser(sys.argv[1])))
print(os.path.sep if os.path.exists(root) and os.path.samefile(root, os.path.sep) else root)
PY
}

codex_root=$(canonical_root "$codex_root")
claude_root=$(canonical_root "$claude_root")

install_one() {
  label=$1
  root=$2
  [[ -n "$root" ]] || { printf 'error: unsafe %s root\n' "$label" >&2; exit 2; }
  [[ "$root" != / ]] || { printf 'error: unsafe %s root\n' "$label" >&2; exit 2; }
  parent="$root/skills"
  destination="$parent/agent-workspace-setup"
  [[ "$destination" == */skills/agent-workspace-setup ]] || exit 2
  printf '%s: %s\n' "$label" "$destination"
  $dry_run && return 0
  if [[ ( -e "$destination" || -L "$destination" ) ]] && ! $assume_yes; then
    read -r -p "Replace existing $label skill? [y/N] " answer
    [[ "$answer" == y || "$answer" == Y ]] || return 0
  fi
  mkdir -p "$parent"
  stage="$parent/.agent-workspace-setup.tmp.$$"
  rm -rf "$stage"
  mkdir "$stage"
  cp -R "$source_dir/." "$stage/"
  rm -rf "$destination"
  mv "$stage" "$destination"
}

preview() {
  case "$runtime" in
    --codex) printf 'Codex: %s/skills/agent-workspace-setup\n' "$codex_root" ;;
    --claude) printf 'Claude: %s/skills/agent-workspace-setup\n' "$claude_root" ;;
    --all)
      printf 'Codex: %s/skills/agent-workspace-setup\n' "$codex_root"
      printf 'Claude: %s/skills/agent-workspace-setup\n' "$claude_root"
      ;;
  esac
}

if ! "$assume_yes" && ! "$dry_run"; then
  preview
  printf 'Install to these destinations? [y/N] '
  read -r answer
  [[ "$answer" == y || "$answer" == Y ]] || exit 0
fi

case "$runtime" in
  --codex) install_one Codex "$codex_root" ;;
  --claude) install_one Claude "$claude_root" ;;
  --all)
    install_one Codex "$codex_root"
    install_one Claude "$claude_root"
    ;;
esac
