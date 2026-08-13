#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture=$(mktemp -d)
empty_fixture=$(mktemp -d)
trap 'rm -rf "$fixture" "$empty_fixture"' EXIT

mkdir -p "$fixture/.github/workflows" "$fixture/src" "$fixture/a/b" "$fixture/a/b/c" "$fixture/a/b/c/d"
printf '%s\n' '{"scripts":{"test":"vitest run","lint":"eslint ."}}' > "$fixture/package.json"
printf '%s\n' '# Existing rules' > "$fixture/AGENTS.md"
printf '%s\n' 'name: CI' > "$fixture/.github/workflows/ci.yml"
printf '%s\n' 'nested rules' > "$fixture/a/b/AGENTS.md"
printf '%s\n' 'too deep' > "$fixture/a/b/c/AGENTS.md"
printf '%s\n' 'nested workflow' > "$fixture/a/b/c/Makefile"
printf '%s\n' 'too deep' > "$fixture/a/b/c/d/Makefile"
git -C "$fixture" init -q
git -C "$fixture" add .
git -C "$fixture" -c user.name=Test -c user.email=test@example.com commit -qm fixture
printf '%s\n' dirty > "$fixture/src/change.txt"

output=$("$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$fixture")
grep -Fq 'Route candidate: adopt' <<<"$output"
grep -Fq 'Worktree: dirty' <<<"$output"
grep -Fq 'HEAD: ' <<<"$output"
grep -Fq 'Default branch candidate: master' <<<"$output"
grep -Fq 'AGENTS.md' <<<"$output"
grep -Fq 'package.json' <<<"$output"
grep -Fq '.github/workflows/ci.yml' <<<"$output"
grep -Fq 'test: vitest run' <<<"$output"
grep -Fq 'lint: eslint .' <<<"$output"
candidate_commands=${output#*'## Candidate commands'}
grep -Fq 'test: vitest run' <<<"$candidate_commands"
grep -Fq 'lint: eslint .' <<<"$candidate_commands"
for heading in Repository Git 'Agent files' 'Native agent files' Manifests Automation 'Candidate commands'; do
  grep -Fq "## $heading" <<<"$output"
done

existing_empty=$(mktemp -d)
git -C "$existing_empty" init -q
existing_output=$("$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$existing_empty")
grep -Fq 'Route candidate: adopt' <<<"$existing_output"
rm -rf "$existing_empty"
grep -Fq 'a/b/AGENTS.md' <<<"$output"
! grep -Fq 'a/b/c/AGENTS.md' <<<"$output"
grep -Fq 'a/b/c/Makefile' <<<"$output"
! grep -Fq 'a/b/c/d/Makefile' <<<"$output"

empty_output=$("$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$empty_fixture")
grep -Fq 'Route candidate: bootstrap' <<<"$empty_output"
grep -Fq 'Repository: no' <<<"$empty_output"
grep -Fq 'Worktree: not-applicable' <<<"$empty_output"
grep -Fq 'Branch: not-applicable' <<<"$empty_output"
grep -Fq 'HEAD: not-applicable' <<<"$empty_output"
for heading in Repository Git 'Agent files' 'Native agent files' Manifests Automation 'Candidate commands'; do
  grep -Fq "## $heading" <<<"$empty_output"
done

malformed_fixture=$(mktemp -d)
printf '%s\n' '{bad' > "$malformed_fixture/package.json"
set +e
"$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$malformed_fixture" >/dev/null 2>&1
malformed_status=$?
set -e
rm -rf "$malformed_fixture"
test "$malformed_status" -ne 0

blocked_fixture=$(mktemp -d)
mkdir "$blocked_fixture/private"
printf '%s\n' hidden > "$blocked_fixture/private/AGENTS.md"
chmod 000 "$blocked_fixture/private"
set +e
"$repo_root/skills/agent-workspace-setup/scripts/inspect-project.sh" "$blocked_fixture" >/dev/null 2>&1
blocked_status=$?
set -e
chmod 700 "$blocked_fixture/private"
rm -rf "$blocked_fixture"
test "$blocked_status" -ne 0
