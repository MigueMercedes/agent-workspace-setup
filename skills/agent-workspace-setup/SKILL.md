---
name: agent-workspace-setup
description: Use when preparing a new repository or adopting an existing repository for Codex, Claude Code, AGENTS.md, CLAUDE.md, project skills, agent tools, or multi-repository agent workflows.
---

# Agent Workspace Setup

Install a durable agentic workflow from repository evidence. The workflow is
the product; `AGENTS.md`, `CLAUDE.md`, and optional runtime agent files are its
project-specific delivery mechanism. A setup request starts a proposal;
approval authorizes the exact listed mutations.

## Required gate

1. Run [`scripts/inspect-project.sh`](scripts/inspect-project.sh) for every
   repository in scope and read relevant repository sources.
   If no repository path or inspectable target is available, ask for it and
   stop; a hypothetical proposal cannot satisfy the evidence gate.
2. Select `bootstrap` or `adopt`; load [`references/audit.md`](references/audit.md)
   and [`references/workflow.md`](references/workflow.md).
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
- **Workflow:** include these labeled subfields:
  - **Orchestrator:** ownership of decomposition, routing, review, verification,
    and synthesis.
  - **Delegation:** direct-work threshold, bounded task contract, fresh
    implementer where applicable, worktree isolation, user-change preservation,
    and non-overlapping parallelism boundary.
  - **Routing:** available capability tiers and verified runtime values or an
    explicit `unverified`, plus escalation triggers. Always include the semantic
    three-row matrix from `workflow.md`. Persist no model or effort value until
    the runtime proves it.
  - **Task loop:** focused checks, independent specification review, independent
    quality review, and the bounded fix/escalation limit.
  - **Completion:** independent whole-change review, fresh final verification,
    and conservative cleanup of owned integrated worktrees.
  - **Runtime targets:** exact Codex and Claude files or an explicit reason each
    runtime needs none. Name `.codex/agents/*.toml` and
    `.claude/agents/*.md` explicitly. `CLAUDE.md` remains thin.
- **Rule preservation:** existing stronger rules retained; every conflict and
  resolution rationale. Replace an existing rule only with an equivalent or
  stronger approved rule.
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
