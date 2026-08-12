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
4. Apply only approved edits using
   [`references/agents-md.md`](references/agents-md.md) and
   [`references/claude-md.md`](references/claude-md.md).
5. Request separate approval for every tool, plugin, or skill installation.
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
- **Optional installations:** purpose and scope, or `none`.
- **Checks:** exact commands and document checks to run after approval.
- **Assumptions:** decisions not established by repository facts.
- **Exclusions:** files, installations, and behavior intentionally untouched.

End with one approval question per repository. Ask a separate installation
question after edit approval; silence or partial approval does not approve the
remaining targets.
