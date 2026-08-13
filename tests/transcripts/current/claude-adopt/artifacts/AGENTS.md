# Existing strict rules

- Every behavior change requires a failing test observed before implementation.
- Before completion, run `npm test` and `npm run lint`; both must pass.
- Never weaken these gates to save time.

# Shared policy

The strict rules above are authoritative and override everything below.
`CLAUDE.md` imports this file.

## Commands

`npm test` and `npm run lint` run from the repository root. Both are currently
no-op stubs in `package.json`: a passing exit status is an executed gate with
no assertions, never evidence of coverage. Report it that way.

## Agentic workflow

### Orchestrator ownership

The orchestrator owns decomposition, routing, review, verification, and
synthesis, and keeps requirements, approval boundaries, and final integration
in the main thread. Subagents return bounded results; they never redefine scope
or declare the whole change complete.

### Delegation and isolation

- Keep trivial and small work in the orchestrator. Delegate only for real
  isolation, specialization, or parallelism.
- A delegated task states inputs, allowed files, expected output, verification,
  stop condition, validated base commit, and upstream dependencies. Use a fresh
  implementer per delegated implementation task; reuse only when continuity is
  essential.
- Parallelize only tasks with no dependency and non-overlapping files and
  mutable state. Serialize shared-file, migration, schema, generated-artifact,
  and shared-environment work.
- Preserve uncommitted user work. Serialize tasks that depend on it. Delegated
  writes start from the recorded parent commit containing every dependency. Use
  native worktree isolation only after verifying it creates from that exact
  base; otherwise create an explicit worktree from the validated base and start
  the agent inside it without native isolation.

### Routing

Route by capability tier, chosen against the runtime's effective model and
effort list at the time of the task:

| Work | Tier |
|---|---|
| Search, inventory, formatting, mechanical bounded work | lowest supported |
| Normal implementation, tests, ordinary review | balanced / runtime default |
| Architecture, subtle debugging, security, migrations, final review | highest justified supported |

Model identifiers and effort values are unverified for this repository and are
deliberately not pinned here. Never write an unverified model identifier or
effort value into project configuration.

Escalate when the same point fails twice, evidence exposes greater risk or
complexity, or review shows the tier is unreliable. Escalation may mean
narrower scope, a stronger model, higher supported effort, or a different agent.

### Review and completion

1. The implementer makes the bounded change and runs focused checks.
2. An independent specification reviewer checks requirement compliance; then an
   independent quality reviewer checks code quality, security, and test
   evidence. The implementer never reviews its own work.
3. Findings return through a bounded fix loop: at most two correction passes
   for the same finding at the same tier, then re-scope or escalate.
4. After task reviews pass, run an independent whole-change review across
   interactions between tasks.
5. The orchestrator runs fresh verification against the final working tree
   before claiming completion. Earlier agent reports are inputs, not proof.

Every completion report has two explicit lists:

- **Verified:** check, command or method, and result.
- **Unverified:** every check that was omitted, blocked, or failed, and the
  reason — including any gate blocked by tool permissions, sandboxing, or a
  missing runtime.

A blocked or skipped check is never reported as success, and an unrun command
is never an inferred success.

### Worktrees

Remove only owned, completed, and integrated worktrees that are clean.
Preserve dirty, unmerged, foreign, or ambiguous worktrees and report them.

### Native agent files

This repository uses no `.codex/agents/*.toml` and no `.claude/agents/*.md`.
Routing lives in this file so it survives without any skill installed. Add
native agent files only when repeated project roles justify them and the exact
model and effort values have been verified against the effective runtime.
