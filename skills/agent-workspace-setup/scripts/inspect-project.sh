#!/usr/bin/env bash
set -euo pipefail

target=${1:-.}
[[ -r "$target" ]] || { printf 'Unreadable target: %s\n' "$target" >&2; exit 1; }
target=$(cd "$target" && pwd)

printf '%s\n' '## Repository'
has_entry=false
while IFS= read -r entry; do
  has_entry=true
  break
done < <(find "$target" -mindepth 1 \( -name .git -o -name node_modules \) -prune -o -print -quit)
if "$has_entry"; then route=adopt; else route=bootstrap; fi
printf 'Route candidate: %s\n\n' "$route"

printf '%s\n' '## Git'
if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  [[ -n "$(git -C "$target" status --porcelain)" ]] && state=dirty || state=clean
  printf 'Repository: yes\nWorktree: %s\nBranch: %s\n' \
    "$state" "$(git -C "$target" branch --show-current)"
else
  printf 'Repository: no\nWorktree: not-applicable\nBranch: not-applicable\n'
fi
printf '\n%s\n' '## Agent files'
{ find "$target" -mindepth 1 -maxdepth 3 \( -name .git -o -name node_modules \) -prune -o \
  -type f \( -name AGENTS.md -o -name CLAUDE.md -o -name GEMINI.md \) -print \
  2> >(sed 's/^/Warning: /' >&2) || true; } |
  sed "s#^$target/##" | sort

printf '\n%s\n' '## Manifests'
{ find "$target" -mindepth 1 -maxdepth 3 \( -name .git -o -name node_modules \) -prune -o \
  -type f \( -name package.json -o -name pyproject.toml -o -name Cargo.toml -o -name go.mod -o -name pom.xml -o -name build.gradle -o -name requirements.txt \) -print \
  2> >(sed 's/^/Warning: /' >&2) || true; } |
  sed "s#^$target/##" | sort
if [[ -f "$target/package.json" ]]; then
  python3 - "$target/package.json" <<'PY'
import json
import sys
with open(sys.argv[1], encoding="utf-8") as source:
    scripts = json.load(source).get("scripts", {})
for name in sorted(scripts):
    print(f"{name}: {scripts[name]}")
PY
fi

printf '\n%s\n' '## Automation'
{ find "$target" -mindepth 1 -maxdepth 4 \( -name .git -o -name node_modules \) -prune -o \
  \( -type f \( -path '*/.github/workflows/*' -o -name Makefile -o -name Taskfile.yml \) \) -print \
  2> >(sed 's/^/Warning: /' >&2) || true; } |
  sed "s#^$target/##" | sort

printf '\n%s\n' '## Candidate commands'
printf 'Route candidate: %s\n' "$route"
