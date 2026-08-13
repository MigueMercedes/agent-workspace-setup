# Existing strict rules

- Every behavior change requires a failing test observed before implementation.
- Before completion, run `npm test` and `npm run lint`; both must pass.
- Never weaken these gates to save time.

# Agentic workflow

## Orchestrator ownership

The orchestrator owns decomposition, routing, review, verification, and
synthesis, and keeps the task's requirements, approval boundaries, and final
integration in the main thread. Subagents return bounded results. A subagent
never redefines scope and never declares the whole change complete.

## Delegation and isolation

- Trivial and small work stays in the orchestrator. Delegate only when it buys
  real isolation, specialization, or parallelism.
- A delegated task states its inputs, allowed files, expected output,
  verification, stop condition, validated base commit, and upstream
  dependencies. Use a fresh implementer for each delegated implementation task;
  reuse one only when continuity is essential.

## Parallelism

Parallelize only tasks with no dependency between them and no overlapping files
or mutable state. Serialize shared-file, migration, schema, generated-artifact,
and shared-environment work.

## Preserving uncommitted work

Uncommitted changes in the working tree belong to the user. Never revert, stage,
commit, or overwrite them to make a task easier. Serialize any task that depends
on uncommitted work. Delegated writes start from the recorded parent commit that
already contains every dependency. Use a runtime's native worktree isolation
only after verifying it creates from that exact base; otherwise create an
explicit worktree from the validated base and start the agent inside it without
adding native isolation.

## Adaptive routing

Choose the capability tier from the nature of the work, not the size of the
diff:

| Work | Capability tier |
|---|---|
| Search, inventory, formatting, other mechanical bounded work | lowest supported |
| Normal implementation, tests, ordinary review | balanced / runtime default |
| Architecture, subtle debugging, security, migrations, final review | highest justified supported |

Inspect the runtime's effective model list, account restrictions, existing agent
definitions, and supported effort levels before selecting, and select
semantically. Model and effort availability for this repository is currently
**unverified**, so no exact model identifier or effort value is recorded here;
never write an unverified one into project configuration.

Escalate when the same point fails twice, when evidence exposes greater risk or
complexity, or when review shows the chosen tier is unreliable. Escalation may
mean narrower scope, a stronger model, higher supported effort, or a different
agent.

## Review, fix, and completion

1. The implementer makes the bounded change and runs focused checks.
2. An independent specification reviewer checks requirement compliance, then an
   independent quality reviewer checks code quality, security, and test
   evidence. The implementer never reviews its own work.
3. Findings return to the implementer through a bounded fix loop: at most two
   correction passes for the same finding at the same routing tier, then
   re-scope or escalate.
4. After all task reviews pass, run an independent review of the whole change,
   covering interactions between tasks.
5. The orchestrator synthesizes results and runs fresh verification against the
   final working tree before claiming completion. An agent's report is an
   evidence input, never completion proof.

## Worktree lifecycle

Remove only worktrees you own that are completed, integrated, and clean.
Preserve dirty, unmerged, foreign, or ambiguous worktrees and report them
instead.
