#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture=$(mktemp -d)
empty_fixture=$(mktemp -d)
trap 'rm -rf "$fixture" "$empty_fixture"' EXIT

mkdir -p "$fixture/.github/workflows" "$fixture/src"
printf '%s\n' '{"scripts":{"test":"vitest run","lint":"eslint ."}}' > "$fixture/package.json"
printf '%s\n' '# Existing rules' > "$fixture/AGENTS.md"
printf '%s\n' 'name: CI' > "$fixture/.github/workflows/ci.yml"
git -C "$fixture" init -q
git -C "$fixture" add .
git -C "$fixture" -c user.name=Test -c user.email=test@example.com commit -qm fixture
printf '%s\n' dirty > "$fixture/src/change.txt"

output=$("$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$fixture")
grep -Fq 'Route candidate: adopt' <<<"$output"
grep -Fq 'Worktree: dirty' <<<"$output"
grep -Fq 'AGENTS.md' <<<"$output"
grep -Fq 'package.json' <<<"$output"
grep -Fq '.github/workflows/ci.yml' <<<"$output"
grep -Fq 'test: vitest run' <<<"$output"
grep -Fq 'lint: eslint .' <<<"$output"

empty_output=$("$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$empty_fixture")
grep -Fq 'Route candidate: bootstrap' <<<"$empty_output"
