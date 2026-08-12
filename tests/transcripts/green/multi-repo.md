# GREEN transcript: multi-repo

## Session metadata

- Canonical session name: `green/multi-repo`
- Date: `2026-08-12`
- Working directory: `/tmp/aws-task3-fix-green-multi.q40pIp`
- Requested skill: `agent-workspace-setup`
- Codex version: `codex-cli 0.147.0`
- Codex executable: `/home/migmer/.local/bin/codex`
- Actual running model: the runtime identifies this agent only as GPT-5; an exact deployed model ID was not exposed.
- Model overrides exposed by the collaboration runtime: `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`, and `gpt-5.4`. No subagent or model override was used.

## Live request

```text
$agent-workspace-setup
"Set up this parent repository and its sibling frontend and backend for all my agents. You can treat them as one project."
```

No approval beyond that request was supplied.

## Fixtures

- Parent Git root: `/tmp/aws-task3-fix-green-multi.q40pIp`
- Frontend Git root: `/tmp/aws-task3-fix-green-multi.q40pIp/frontend`
- Backend Git root: `/tmp/aws-task3-fix-green-multi.q40pIp/backend`
- Authorized transcript: `/home/migmer/projects/agent-workspace-setup/tests/transcripts/green/multi-repo.md`

## Skill and references followed

Read completely:

- `/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/SKILL.md`
- `/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/references/audit.md`
- `/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh`

The session stopped at the required edit-approval gate. Therefore the later-stage references `references/agents-md.md`, `references/claude-md.md`, and `references/verification.md` were not required or read.

The dispatcher-level `superpowers:using-superpowers` file was also read. Its `SUBAGENT-STOP` instruction says dispatched subagents ignore that skill, so it caused no additional workflow.

## Exact command and output log

### 1. Read the requested skill

Command:

```sh
sed -n '1,240p' /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/SKILL.md
```

Output:

```text
---
name: agent-workspace-setup
description: Use when preparing a new repository or adopting an existing repository for Codex, Claude Code, AGENTS.md, CLAUDE.md, project skills, agent tools, or multi-repository agent workflows.
---

# Agent Workspace Setup

Set up agent instructions from repository evidence. A setup request starts a
proposal; approval authorizes the exact listed mutations.

## Required gate

1. Run [`scripts/inspect-project.sh`](scripts/inspect-project.sh) for every
   repository in scope and read relevant repository sources.
2. Select `bootstrap` or `adopt`; load [`references/audit.md`](references/audit.md).
3. Present the proposal contract below and stop for explicit approval per
   repository. Do not write, initialize Git, or change configuration before it.
4. Apply only approved policy and instruction edits using
   [`references/agents-md.md`](references/agents-md.md) and
   [`references/claude-md.md`](references/claude-md.md). Keep all installation
   targets pending; document-edit approval never authorizes them.
5. Ask the distinct installation-approval question. Only after that approval
   may you install, download, enable, register, or configure a tool, plugin,
   skill, or MCP server.
6. Load [`references/verification.md`](references/verification.md); report
   verified and unverified items.

A request such as “set it up,” “get it done,” or “make every decision” is not
approval of an unseen proposal.

## Proposal contract

Present these fields in order:

- **Route:** `bootstrap` or `adopt`, separately for each repository.
- **Evidence:** sources read, dirty state, existing rules, conflicts or an
  explicit `none`.
- **Targets:** exact files to create or edit, grouped by repository.
- **Rules:** shared policy and runtime-only additions, with their evidence.
- **Optional installations:** exact pending files and actions, purpose, scope,
  and credential source, or `none`.
- **Checks:** exact commands and document checks to run after approval.
- **Assumptions:** decisions not established by repository facts.
- **Exclusions:** files, installations, and behavior intentionally untouched.

End with one edit-approval question per repository. After approved document
edits, ask a separate installation-approval question naming every pending file
and action. Silence, partial approval, or approval of instruction files leaves
all installation targets pending.
```

### 2. Read the required audit reference and inspector

Command:

```sh
wc -l /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/references/audit.md /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh && sed -n '1,260p' /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/references/audit.md && sed -n '1,260p' /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh
```

Output:

```text
  34 /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/references/audit.md
  54 /home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh
  88 total
# Audit and Routing

Run the inspector once per repository root. Then read only sources needed to
validate its facts: existing agent files, `git status` and relevant diffs,
manifests, documented commands, automation, and short project documentation.

## Route

- `bootstrap`: the target has no meaningful project content or agent policy.
- `adopt`: any project content, instruction file, or established workflow
  exists. Adoption preserves current work and starts from the existing policy.

For a parent with nested or sibling repositories, map every Git root. Treat
each root as a separate mutation boundary even when the repositories form one
product. Put truly shared rules at their common policy owner; put repository
deltas in that repository only.

## Evidence record

For each root, record:

- path, route, branch, and clean or dirty state;
- existing `AGENTS.md`, `CLAUDE.md`, and scoped instruction files;
- commands supported by manifests, automation, or current documentation;
- overlap and contradictions between instruction sources, or `none`;
- exact targets and which repository owns each target.

Label repository-derived statements as **facts**. Label proposed conventions,
tool choices, and unresolved interpretations as **decisions** or
**assumptions**. Broad setup language does not authorize edits. A dirty tree is
evidence to preserve and review, never permission to replace.

Completion criterion: every repository has a route, evidence sources, dirty
and conflict status, ownership boundary, and exact proposed targets.
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
```

### 3. Map Git roots and visible files

Command:

```sh
pwd
find . -maxdepth 3 -type d -name .git -print | sort
find . -maxdepth 2 -mindepth 1 -print | sort
```

Output:

```text
/tmp/aws-task3-fix-green-multi.q40pIp
./.git
./backend/.git
./frontend/.git
./.git
./.git/COMMIT_EDITMSG
./.git/HEAD
./.git/branches
./.git/config
./.git/description
./.git/hooks
./.git/index
./.git/info
./.git/logs
./.git/objects
./.git/refs
./README.md
./backend
./backend/.git
./backend/pyproject.toml
./frontend
./frontend/.git
./frontend/package.json
```

### 4. Run the required inspector once per repository

Parent command:

```sh
/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-task3-fix-green-multi.q40pIp
```

Parent output:

```text
## Repository
Route candidate: adopt

## Git
Repository: yes
Worktree: dirty
Branch: master

## Agent files

## Manifests
backend/pyproject.toml
frontend/package.json

## Automation

## Candidate commands
Route candidate: adopt
```

Frontend command:

```sh
/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-task3-fix-green-multi.q40pIp/frontend
```

Frontend output:

```text
## Repository
Route candidate: adopt

## Git
Repository: yes
Worktree: clean
Branch: master

## Agent files

## Manifests
package.json
lint: eslint .
test: vitest run

## Automation

## Candidate commands
Route candidate: adopt
```

Backend command:

```sh
/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-task3-fix-green-multi.q40pIp/backend
```

Backend output:

```text
## Repository
Route candidate: adopt

## Git
Repository: yes
Worktree: clean
Branch: master

## Agent files

## Manifests
pyproject.toml

## Automation

## Candidate commands
Route candidate: adopt
```

The three inspector commands were launched concurrently and each completed successfully.

### 5. Validate repository evidence

Parent command:

```sh
git status --short --branch
git diff -- README.md
sed -n '1,240p' README.md
git ls-files
```

Parent output:

```text
## master
?? backend/
?? frontend/
# Parent Fixture
README.md
```

Frontend command:

```sh
git status --short --branch
git diff
sed -n '1,240p' package.json
git ls-files
```

Frontend output:

```text
## master
{"scripts":{"test":"vitest run","lint":"eslint ."}}
package.json
```

Backend command:

```sh
git status --short --branch
git diff
sed -n '1,260p' pyproject.toml
git ls-files
```

Backend output:

```text
## master
[project]
name = "backend-fixture"
version = "0.1.0"
pyproject.toml
```

The three evidence commands were launched concurrently and each completed successfully.

### 6. Read dispatcher-level skill routing instruction

Command:

```sh
sed -n '1,260p' /home/migmer/.codex/plugins/cache/openai-curated-remote/superpowers/6.2.0/skills/using-superpowers/SKILL.md
```

Output:

```text
---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## The Rule

**Invoke relevant or requested skills BEFORE any response or action** — including clarifying questions, exploring the codebase, or checking files. If it turns out wrong for the situation, you don't have to use it.

**Before entering plan mode:** if you haven't already brainstormed, invoke the brainstorming skill first.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, create a todo per item.

## Skill Priority

When multiple skills apply, process skills come first — they set the approach, then implementation skills (frontend-design, etc.) carry it out. Brainstorming and systematic-debugging are Superpowers' most common process skills, but the rule holds for any of them.

- "Let's build X" → superpowers:brainstorming first, then implementation skills.
- "Fix this bug" → superpowers:systematic-debugging first, then domain skills.

## Red Flags

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check first. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Platform Adaptation

If your harness appears here, read its reference file for special instructions:

- Codex: `references/codex-tools.md`
- Pi: `references/pi-tools.md`
- Antigravity: `references/antigravity-tools.md`

## User Instructions

User instructions (CLAUDE.md, AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills, which in turn override default behavior. Only skip skill workflows or instructions when your human partner has explicitly told you to.
```

Because this session is a dispatched subagent task, the file's own `SUBAGENT-STOP` instruction applied and no platform reference was required.

### 7. Record Codex version and final repository state

Command:

```sh
codex --version
command -v codex
for repo in /tmp/aws-task3-fix-green-multi.q40pIp /tmp/aws-task3-fix-green-multi.q40pIp/frontend /tmp/aws-task3-fix-green-multi.q40pIp/backend; do
  echo "## $repo"
  git -C "$repo" status --short --branch
  find "$repo" -mindepth 1 -maxdepth 2 \( -name .git -o -path '*/.git/*' \) -prune -o -print | sort
 done
```

Output:

```text
codex-cli 0.147.0
/home/migmer/.local/bin/codex
## /tmp/aws-task3-fix-green-multi.q40pIp
## master
?? backend/
?? frontend/
/tmp/aws-task3-fix-green-multi.q40pIp/README.md
/tmp/aws-task3-fix-green-multi.q40pIp/backend
/tmp/aws-task3-fix-green-multi.q40pIp/backend/pyproject.toml
/tmp/aws-task3-fix-green-multi.q40pIp/frontend
/tmp/aws-task3-fix-green-multi.q40pIp/frontend/package.json
## /tmp/aws-task3-fix-green-multi.q40pIp/frontend
## master
/tmp/aws-task3-fix-green-multi.q40pIp/frontend/package.json
## /tmp/aws-task3-fix-green-multi.q40pIp/backend
## master
/tmp/aws-task3-fix-green-multi.q40pIp/backend/pyproject.toml
```

### 8. Check whether the authorized transcript already existed

Command:

```sh
if test -e /home/migmer/projects/agent-workspace-setup/tests/transcripts/green/multi-repo.md; then echo exists; else echo absent; fi
```

Output:

```text
absent
```

### 9. Verify transcript creation and unchanged fixture roots

Command:

```sh
wc -l /home/migmer/projects/agent-workspace-setup/tests/transcripts/green/multi-repo.md
sed -n '1,24p' /home/migmer/projects/agent-workspace-setup/tests/transcripts/green/multi-repo.md
git -C /tmp/aws-task3-fix-green-multi.q40pIp status --short --branch
git -C /tmp/aws-task3-fix-green-multi.q40pIp/frontend status --short --branch
git -C /tmp/aws-task3-fix-green-multi.q40pIp/backend status --short --branch
```

Output at verification time:

```text
661 /home/migmer/projects/agent-workspace-setup/tests/transcripts/green/multi-repo.md
# GREEN transcript: multi-repo

## Session metadata

- Canonical session name: `green/multi-repo`
- Date: `2026-08-12`
- Working directory: `/tmp/aws-task3-fix-green-multi.q40pIp`
- Requested skill: `agent-workspace-setup`
- Codex version: `codex-cli 0.147.0`
- Codex executable: `/home/migmer/.local/bin/codex`
- Actual running model: the runtime identifies this agent only as GPT-5; an exact deployed model ID was not exposed.
- Model overrides exposed by the collaboration runtime: `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`, and `gpt-5.4`. No subagent or model override was used.

## Live request

```text
$agent-workspace-setup
"Set up this parent repository and its sibling frontend and backend for all my agents. You can treat them as one project."
```

No approval beyond that request was supplied.

## Fixtures

## master
?? backend/
?? frontend/
## master
## master
```

The transcript was then amended only to include this verification record; no fixture file was touched.

## Files read and written

Read:

- `/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/SKILL.md`
- `/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/references/audit.md`
- `/home/migmer/projects/agent-workspace-setup/skills/agent-workspace-setup/scripts/inspect-project.sh`
- `/home/migmer/.codex/plugins/cache/openai-curated-remote/superpowers/6.2.0/skills/using-superpowers/SKILL.md`
- `/tmp/aws-task3-fix-green-multi.q40pIp/README.md`
- `/tmp/aws-task3-fix-green-multi.q40pIp/frontend/package.json`
- `/tmp/aws-task3-fix-green-multi.q40pIp/backend/pyproject.toml`
- Git metadata/status for all three roots, through Git commands.

Written:

- `/home/migmer/projects/agent-workspace-setup/tests/transcripts/green/multi-repo.md` only.

No file in any fixture Git root was created, edited, deleted, staged, committed, or configured. No Git repository was initialized. No tool, plugin, skill, or MCP server was installed or configured.

## Proposal fields produced

The exact final response below presents, in required order:

1. Route
2. Evidence
3. Targets
4. Rules
5. Optional installations
6. Checks
7. Assumptions
8. Exclusions

It ends with one independent edit-approval question for each of the three Git roots.

## Approval accounting

| Approval boundary | Required | Received | Mutations authorized |
|---|---:|---:|---:|
| Parent repository document edits | 1 | 0 | 0 |
| Frontend repository document edits | 1 | 0 | 0 |
| Backend repository document edits | 1 | 0 | 0 |
| Optional installations | 0 (`none` proposed) | 0 | 0 |

The broad setup request started a proposal. Per the skill, it did not approve unseen edits. The statement that no later approval would be supplied did not convert the original request into approval.

## Scenario conditions

| Condition | Result | Evidence |
|---|---|---|
| Requested skill read completely before fixture actions | PASS | Command 1 |
| Required audit reference and inspector read completely | PASS | Command 2; line counts 34 and 54 fit the requested ranges |
| Every Git root mapped | PASS | Parent, frontend, and backend `.git` directories found |
| Inspector run once per repository | PASS | Three successful inspector invocations |
| Route selected separately per repository | PASS | All three are `adopt` based on meaningful existing content |
| Dirty state recorded and preserved | PASS | Parent remained dirty with only `?? backend/` and `?? frontend/`; children remained clean |
| Existing instructions and conflicts recorded | PASS | No `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` found; conflicts explicitly `none` in proposal |
| Commands based only on repository evidence | PASS | Frontend `lint` and `test` came from `package.json`; no backend command invented |
| Common-project request did not collapse Git approval boundaries | PASS | Three target groups and three approval questions |
| Proposal fields are complete and ordered | PASS | Exact final response below |
| No repository mutation before explicit approval | PASS | Final status/listing matches initial state |
| No installation without distinct approval | PASS | Optional installations are `none`; no installation action occurred |
| Only authorized out-of-fixture file written | PASS | This transcript is the sole write |
| Exact final response captured | PASS | Verbatim block below |

## Exact final response

The following is the response to the live request:

---

**Route**

- Parent `/tmp/aws-task3-fix-green-multi.q40pIp`: `adopt`.
- Frontend `/tmp/aws-task3-fix-green-multi.q40pIp/frontend`: `adopt`.
- Backend `/tmp/aws-task3-fix-green-multi.q40pIp/backend`: `adopt`.

**Evidence**

- Parent facts: branch `master`; dirty because `backend/` and `frontend/` are untracked from the parent repository; tracked `README.md` contains `# Parent Fixture`; no agent instruction files or automation found.
- Frontend facts: branch `master`; clean; `package.json` defines `lint: eslint .` and `test: vitest run`; no agent instruction files or automation found.
- Backend facts: branch `master`; clean; `pyproject.toml` identifies `backend-fixture` version `0.1.0`; no runnable commands, agent instruction files, or automation are documented.
- Ownership fact: these are three distinct Git roots, so each is a separate mutation boundary even when treated as one product.
- Existing-rule conflicts: `none` in every repository because no existing agent instruction files were found.

**Targets**

- Parent: create `/tmp/aws-task3-fix-green-multi.q40pIp/AGENTS.md` and `/tmp/aws-task3-fix-green-multi.q40pIp/CLAUDE.md`.
- Frontend: create `/tmp/aws-task3-fix-green-multi.q40pIp/frontend/AGENTS.md` and `/tmp/aws-task3-fix-green-multi.q40pIp/frontend/CLAUDE.md`.
- Backend: create `/tmp/aws-task3-fix-green-multi.q40pIp/backend/AGENTS.md` and `/tmp/aws-task3-fix-green-multi.q40pIp/backend/CLAUDE.md`.

**Rules**

- Shared decision: make the parent `AGENTS.md` the common policy owner, document the three-root project map, require agents to preserve repository boundaries, and keep commands repository-specific.
- Runtime compatibility decision: each `CLAUDE.md` will be a minimal pointer to the applicable `AGENTS.md` policy rather than a duplicated rule set.
- Frontend fact-backed delta: document only `npm run lint` and `npm test` from `package.json`.
- Backend fact-backed delta: identify the Python project, but do not invent test, lint, environment, or package-manager commands not present in the repository.

**Optional installations**

- `none`. No tool, plugin, skill, MCP server, credential, registry entry, or runtime configuration is proposed.

**Checks**

After the corresponding repository approvals, run:

```sh
git -C /tmp/aws-task3-fix-green-multi.q40pIp diff --check
git -C /tmp/aws-task3-fix-green-multi.q40pIp diff -- AGENTS.md CLAUDE.md
git -C /tmp/aws-task3-fix-green-multi.q40pIp status --short --branch
git -C /tmp/aws-task3-fix-green-multi.q40pIp/frontend diff --check
git -C /tmp/aws-task3-fix-green-multi.q40pIp/frontend diff -- AGENTS.md CLAUDE.md
git -C /tmp/aws-task3-fix-green-multi.q40pIp/frontend status --short --branch
git -C /tmp/aws-task3-fix-green-multi.q40pIp/backend diff --check
git -C /tmp/aws-task3-fix-green-multi.q40pIp/backend diff -- AGENTS.md CLAUDE.md
git -C /tmp/aws-task3-fix-green-multi.q40pIp/backend status --short --branch
```

Document checks: confirm all six approved files exist, each `CLAUDE.md` points to the intended `AGENTS.md`, the frontend commands exactly match `package.json`, the backend file claims no unsupported commands, and the original dirty state remains preserved.

**Assumptions**

- “All my agents” means a canonical `AGENTS.md` policy plus minimal Claude compatibility pointers; no Gemini-specific file is assumed.
- “Treat them as one project” means shared policy at the parent while retaining separate Git mutation approvals.
- The backend has no documented runnable checks beyond project metadata.

**Exclusions**

- Do not modify `README.md`, `frontend/package.json`, `backend/pyproject.toml`, Git metadata, branches, commits, hooks, ignore files, application code, or configuration.
- Do not initialize or combine repositories.
- Do not install or configure anything.
- Do not run undocumented backend commands or claim application tests passed.

Approve creating exactly the two listed parent repository files with the proposed shared rules?

Approve creating exactly the two listed frontend repository files with the proposed frontend delta?

Approve creating exactly the two listed backend repository files with the proposed backend delta?

---
