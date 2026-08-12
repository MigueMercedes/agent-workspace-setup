#!/usr/bin/env bash
set -euo pipefail

target=${1:-.}
[[ -r "$target" ]] || { printf 'Unreadable target: %s\n' "$target" >&2; exit 1; }
target=$(cd "$target" && pwd)

printf '%s\n' '## Repository'
if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  [[ -n "$(python3 - "$target" <<'PY'
import os
import sys
root = sys.argv[1]
print(next((name for name in os.listdir(root) if name not in {'.git', 'node_modules'}), ''))
PY
)" ]]; then route=adopt; else route=bootstrap; fi
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
python3 - "$target" agent <<'PY'
import os, sys
root, kind = sys.argv[1:]
names = {'AGENTS.md', 'CLAUDE.md', 'GEMINI.md'}
for current, dirs, files in os.walk(root, onerror=lambda error: (_ for _ in ()).throw(error)):
    dirs[:] = [d for d in dirs if d not in {'.git', 'node_modules'}]
    dirs.sort()
    depth = len(os.path.relpath(current, root).split(os.sep)) if current != root else 0
    if depth >= 3: dirs[:] = []
    for name in sorted(files):
        if name in names: print(os.path.relpath(os.path.join(current, name), root))
PY

printf '\n%s\n' '## Manifests'
python3 - "$target" <<'PY'
import os, sys
root = sys.argv[1]
names = {'package.json', 'pyproject.toml', 'Cargo.toml', 'go.mod', 'pom.xml', 'build.gradle', 'requirements.txt'}
for current, dirs, files in os.walk(root, onerror=lambda error: (_ for _ in ()).throw(error)):
    dirs[:] = [d for d in dirs if d not in {'.git', 'node_modules'}]
    dirs.sort()
    depth = len(os.path.relpath(current, root).split(os.sep)) if current != root else 0
    if depth >= 3: dirs[:] = []
    for name in sorted(files):
        if name in names: print(os.path.relpath(os.path.join(current, name), root))
PY

printf '\n%s\n' '## Automation'
python3 - "$target" <<'PY'
import os, sys
root = sys.argv[1]
for current, dirs, files in os.walk(root, onerror=lambda error: (_ for _ in ()).throw(error)):
    dirs[:] = [d for d in dirs if d not in {'.git', 'node_modules'}]
    dirs.sort()
    depth = len(os.path.relpath(current, root).split(os.sep)) if current != root else 0
    if depth >= 4: dirs[:] = []
    for name in sorted(files):
        path = os.path.relpath(os.path.join(current, name), root)
        if name in {'Makefile', 'Taskfile.yml'} or path.startswith('.github/workflows/'):
            print(path)
PY

printf '\n%s\n' '## Candidate commands'
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
printf 'Route candidate: %s\n' "$route"
