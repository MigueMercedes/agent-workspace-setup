# AGENTS.md

`AGENTS.md` holds durable policy shared by compatible agents. Start with the
smallest file that changes agent behavior. Existing rules are authoritative:
retain them unless the proposal identifies a conflict, explains the rationale,
and the approved replacement is demonstrably equivalent or stronger.

Include the shared workflow from [`workflow.md`](workflow.md), adapted to the
project and merged with stronger existing policy. `AGENTS.md` must make the
orchestrator, delegation threshold, parallelism boundary, routing matrix,
review/fix loop, fresh verification, and worktree lifecycle durable without
depending on this skill remaining installed.

Also include only evidenced, durable project content:

- scope and precedence where nested instruction files exist;
- verified build, test, lint, formatting, and release commands;
- safety, security, data, architecture, or product invariants;
- the verification gate and what must be reported as unverified;
- pointers to detailed documentation for progressive disclosure.

Prefer a parent `AGENTS.md` for shared multi-repository policy and child files
for real deltas. Each file belongs to its repository approval boundary.

Remove duplicated facts that agents can discover cheaply from manifests,
directory listings, generated files, or tool help. Do not copy runtime-specific
configuration into shared policy. Keep commands only when their source and
working directory are known; run them during verification when safe.

Completion criterion: the shared workflow is complete, every project rule is
durable, scoped, evidenced, and not a duplicate of discoverable facts or
runtime-only configuration; stronger existing workflow rules remain intact.
