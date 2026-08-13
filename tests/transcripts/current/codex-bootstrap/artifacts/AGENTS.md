# Agent Workflow

Inspect repository evidence before acting. Preserve user-authored and unrelated
changes. Derive build, test, lint, formatting, and release commands from project
sources rather than inventing them.

## Orchestration

The main agent owns requirements, approval boundaries, decomposition, routing,
review, verification, synthesis, and final integration. Delegated agents return
bounded results; they do not redefine scope or declare the whole change complete.

Keep trivial and small work in the main agent. Delegate only when isolation,
specialization, or safe parallelism provides value. Each delegated task must
state its inputs, allowed files, expected output, verification, stop condition,
validated base commit, and dependencies. Use a fresh implementer for each
implementation task unless continuity is essential.

Parallelize only independent tasks with non-overlapping files and mutable state.
Serialize shared-file, migration, schema, generated-artifact, and
shared-environment work. Preserve uncommitted user changes and serialize work
that depends on them. A delegated write must start from the recorded commit
containing all dependencies. Use native worktree isolation only after verifying
that it starts from that exact base; otherwise create an explicit worktree from
the validated base and start the agent there.

## Routing

Inspect the effective runtime model list, provider or account restrictions,
existing agent definitions, and supported effort levels before selecting or
persisting them. Never write an unverified model identifier or effort value into
project configuration.

| Work | Capability tier | Runtime selection |
|---|---|---|
| Search, inventory, formatting, and other mechanical bounded work | Lowest supported | Cheapest or fastest verified model and low-cost supported effort |
| Normal implementation, tests, and ordinary review | Balanced/default | Runtime default or verified balanced model and effort |
| Architecture, subtle debugging, security, migrations, and final review | Highest justified supported | Strongest verified model and deepest justified supported reasoning |

Escalate when the same point fails twice, evidence exposes greater risk or
complexity, or review shows the selected tier is unreliable. Escalation may
narrow scope, use a stronger verified model, increase supported effort, or use a
different agent.

## Review and Verification

For each delegated implementation task:

1. The implementer makes the bounded change and runs focused checks.
2. An independent specification reviewer checks requirement compliance.
3. An independent quality reviewer checks quality, security, and test evidence.
4. Return findings through at most two correction passes for the same finding at
   the same routing tier, then re-scope or escalate.

After task reviews pass, run an independent whole-change review across task
interactions. The main agent must then run fresh verification against the final
working tree before claiming completion. Report checks actually run and anything
left unverified.

After integration, remove only owned, completed, integrated worktrees that are
clean and no longer needed. Preserve and report dirty, unmerged, foreign, or
ambiguous worktrees.
