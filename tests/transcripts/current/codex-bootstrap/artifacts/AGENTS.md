# Agent Workflow

## Orchestrator

The orchestrator owns requirements and approval boundaries, decomposition, routing, review, verification, synthesis, and final integration. Keep this context in the main thread. Delegated agents return bounded results; they must not redefine scope or declare the whole change complete.

## Delegation

Keep trivial and small, localized, low-risk work with the orchestrator. Delegate only when specialization, isolation, or safe parallelism provides real value.

Every delegated task must state its inputs, allowed files, expected output, focused verification, stop condition, validated base commit, and upstream dependencies. Use a fresh implementer for each implementation task when applicable; reuse one only when continuity is essential.

Preserve user changes. Serialize work that depends on uncommitted changes. Delegated writes must start from the recorded parent commit containing every dependency. Use native worktree isolation only after verifying that it starts from that exact base; otherwise create an explicit worktree from the validated base and start the agent there without native isolation.

Parallelize only tasks with no dependency and no overlap in files or mutable state. Serialize changes to shared files, schemas, migrations, generated artifacts, and shared environments.

## Routing

Inspect the effective runtime's available models, provider or account restrictions, agent definitions, and supported effort levels before selecting exact values. Never persist an unverified model identifier or effort value.

| Work | Capability tier | Runtime selection |
|---|---|---|
| Search, inventory, formatting, and other mechanical bounded work | Lowest supported | Cheapest and fastest verified model with low-cost supported effort |
| Normal implementation, tests, and ordinary review | Balanced/default | Runtime default or verified balanced model and effort |
| Architecture, subtle debugging, security, migrations, and final review | Highest justified supported | Strongest verified model with the deepest justified supported reasoning |

Escalate when the same point fails twice, evidence reveals greater risk or complexity, or review shows the selected tier is unreliable. Escalation may narrow the scope, select a stronger verified model, increase supported effort, or assign a different agent.

## Task Loop

For each delegated implementation task:

1. The implementer makes the bounded change and runs focused checks.
2. An independent specification reviewer checks requirement compliance.
3. An independent quality reviewer checks correctness, maintainability, security, and test evidence. The implementer must not review its own work.
4. Return findings through a bounded fix loop. Allow at most two correction passes for the same finding at the same routing tier, then re-scope or escalate.

## Completion

After task-level reviews pass, run an independent whole-change review covering interactions between tasks. The orchestrator then synthesizes the results and performs fresh verification against the final working tree before claiming completion.

The final report must list checks actually run under `Verified` and every skipped, blocked, or otherwise unresolved check or behavior under `Unverified`. Never report an unrun check as successful.

After integration, remove only orchestrator-owned worktrees that are completed, integrated, clean, and no longer needed. Preserve and report dirty, unmerged, foreign, or ambiguous worktrees.
