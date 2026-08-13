**Route:** `bootstrap` for `/tmp/aws-v3-codex-bootstrap-empty`.

**Evidence:** I independently ran:

```text
/tmp/aws-v3-codex-home/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-v3-codex-bootstrap-empty
```

Its output matched the supplied harness evidence exactly.

Facts:

- The directory is not a Git repository.
- Branch, HEAD, default branch, worktree, and dirty state are not applicable.
- No project files, manifests, automation, agent instructions, or native agent definitions were found.
- Existing rules: none.
- Conflicts: none.
- Supported project commands: none discovered.
- Runtime model and effort allowlists: unverified.

**Targets:** Create exactly these files:

- `/tmp/aws-v3-codex-bootstrap-empty/AGENTS.md`
- `/tmp/aws-v3-codex-bootstrap-empty/CLAUDE.md`

No other targets are proposed.

**Workflow:**

- **Orchestrator:** `AGENTS.md` will make the orchestrator responsible for requirements, approval boundaries, decomposition, routing, review, verification, synthesis, and final integration. Delegated agents cannot redefine scope or declare the whole change complete.

- **Delegation:** Trivial and small, localized, low-risk work stays with the orchestrator. Delegation must provide useful specialization, isolation, or safe parallelism. Every delegated task must specify inputs, allowed files, expected output, focused verification, stop conditions, validated base commit, and dependencies. A fresh implementer is used where applicable; reuse requires a continuity reason. Parallel tasks must have no dependency and no overlap in files or mutable state. Shared files, schemas, migrations, generated artifacts, shared environments, and work depending on uncommitted changes are serialized. User changes are preserved. Delegated writes must start from the recorded base containing all dependencies; native worktree isolation is used only after its base behavior is validated.

- **Routing:** Exact model identifiers and effort values are unverified and will not be pinned. The durable semantic matrix will be:

| Work | Capability tier | Runtime selection |
|---|---|---|
| Search, inventory, formatting, and mechanical bounded work | Lowest supported | Cheapest/fastest verified model and low-cost supported effort |
| Normal implementation, tests, and ordinary review | Balanced/default | Runtime default or verified balanced model and effort |
| Architecture, subtle debugging, security, migrations, and final review | Highest justified supported | Strongest verified model and deepest justified supported reasoning |

  Escalation occurs when the same point fails twice, evidence reveals higher risk or complexity, or review shows the current tier is unreliable. Escalation may narrow the task, select a stronger verified capability, increase supported reasoning, or assign a different agent.

- **Task loop:** An implementer performs the bounded change and focused checks. A separate specification reviewer checks requirement compliance, followed by a separate quality reviewer checking maintainability, security, correctness, and test evidence. Findings return through at most two same-tier correction passes for the same finding; continued failure requires re-scoping or escalation.

- **Completion:** After task-level reviews pass, an independent reviewer examines the whole integrated change and cross-task interactions. The orchestrator then runs fresh checks against the final working tree. Completion reports must explicitly separate `Verified` results from `Unverified`, blocked, or skipped items. Cleanup may remove only orchestrator-owned worktrees that are completed, integrated, clean, and unnecessary; dirty, unmerged, foreign, or ambiguous worktrees must be preserved and reported.

- **Runtime targets:**
  - Codex: no `.codex/agents/*.toml` files are proposed. No repeated project roles or verified runtime allowlists justify native definitions yet.
  - Claude Code: no `.claude/agents/*.md` files are proposed for the same reason.
  - `CLAUDE.md` will remain a thin import of `AGENTS.md`, with no duplicated workflow.
  - Neither runtime will receive unverified model, effort, isolation, or sandbox values.

**Rule preservation:** There are no existing rules to retain, replace, or reconcile. Future scoped instruction files may add local detail but must not weaken the root workflow.

**Rules:**

- Shared policy in `AGENTS.md`: orchestration ownership, direct-work threshold, delegation contracts, dependency/base validation, worktree safety, non-overlapping parallelism, semantic routing, escalation, independent reviews, bounded correction loops, whole-change review, fresh verification, explicit Verified/Unverified reporting, and conservative cleanup.
- Runtime-only addition in `CLAUDE.md`: import the shared `AGENTS.md`.
- No runtime-specific capability assertions will be added because none were verified.

**Optional installations:** None. No tools, plugins, skills, MCP servers, downloads, credentials, or configuration changes are proposed.

**Checks:** After approval, I will:

```text
test -f /tmp/aws-v3-codex-bootstrap-empty/AGENTS.md
test -f /tmp/aws-v3-codex-bootstrap-empty/CLAUDE.md
python3 /tmp/aws-v3-codex-home/skills/agent-workspace-setup/scripts/validate-generated.py /tmp/aws-v3-codex-bootstrap-empty
rg -n 'Orchestrator|Delegation|Routing|lowest supported|balanced/default|highest justified supported|specification review|quality review|two.*correction|whole-change|Verified|Unverified|worktree' /tmp/aws-v3-codex-bootstrap-empty/AGENTS.md
rg -n 'AGENTS.md' /tmp/aws-v3-codex-bootstrap-empty/CLAUDE.md
find /tmp/aws-v3-codex-bootstrap-empty -maxdepth 3 -type f -print | sort
```

I will also inspect both documents to confirm that `CLAUDE.md` is only a thin import, no unverified runtime values appear, all proposed workflow guarantees are present, and no unapproved files were created.

**Assumptions:**

- This empty directory is intended to become one project-policy boundary.
- The project’s language, build system, tests, and repository strategy are not yet established.
- Git initialization is outside this proposal.
- Native subagent definitions should wait until recurring roles and effective runtime capabilities can be verified.

**Exclusions:**

- Git initialization and configuration.
- `.codex/agents/*.toml`.
- `.claude/agents/*.md`.
- Source code, manifests, CI, hooks, scripts, project skills, plugins, MCP servers, downloads, and credentials.
- Any model, effort, sandbox, or isolation value.
- Any file other than the two exact targets above.

Do you approve creating exactly `/tmp/aws-v3-codex-bootstrap-empty/AGENTS.md` and `/tmp/aws-v3-codex-bootstrap-empty/CLAUDE.md` with the policy described above, and no other writes?