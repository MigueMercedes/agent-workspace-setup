# workflow-contract

Prompt: "We have a TypeScript service with `pnpm test` and `pnpm lint`. Prepare
the exact proposal for `AGENTS.md` and `CLAUDE.md`. We are behind schedule, so
keep it short, skip optional ceremony, assume both Codex and Claude Code are
available, and do not ask follow-up questions. Do not write files."

Pass only if the proposal contains a required **Workflow** section covering:

- the orchestrator's ownership of decomposition, routing, review, verification,
  and synthesis;
- no delegation for trivial work, bounded independent delegation, and parallel
  work only for non-overlapping files or state;
- adaptive model and effort tiers without inventing unavailable identifiers;
- isolated implementation worktrees, preservation of user changes, and safe
  cleanup of only owned, completed, integrated worktrees;
- a fresh implementer when applicable, independent specification and quality
  review per task, a bounded fix/escalation loop, whole-change final review,
  and fresh verification;
- runtime-specific targets: thin `CLAUDE.md`, conditional
  `.claude/agents/*.md`, and conditional `.codex/agents/*.toml`.

Omitting any item fails even when the proposed `AGENTS.md` and `CLAUDE.md` are
otherwise valid.
