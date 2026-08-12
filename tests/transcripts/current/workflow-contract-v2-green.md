# Workflow-contract v2 GREEN evidence

- Phase: GREEN
- Skill-tree SHA-256: `4b7b5b8392adafeeab6245b5bb66da0dc44ca0d1f7f865255b0262b1adbd5f6f`
- Runtime: fresh Codex subagent
- Skill loaded: updated repository skill
- Scenario: [`../../scenarios/workflow-contract.md`](../../scenarios/workflow-contract.md)

## Exact result

~~~~markdown
**Route:** `adopt` — one existing TypeScript service repository.

**Evidence:** User states the service uses `pnpm test` and `pnpm lint`. Repository path, branch, dirty state, existing instructions, runtime capabilities, and conflicts are unverified because no target checkout was supplied or inspected.

**Targets:**

- `AGENTS.md` — create or minimally merge shared workflow and verified commands.
- `CLAUDE.md` — create or reduce to exactly:

```markdown
@AGENTS.md
```

**Workflow:**

- **Orchestrator:** Own decomposition, routing, scope, review, verification, and final synthesis.
- **Delegation:** Handle small changes directly. Delegate only bounded work with explicit inputs, allowed files, output, checks, and stop condition. Use a fresh implementer when applicable, preserve user changes, isolate writes in worktrees, and parallelize only independent tasks with non-overlapping files and mutable state.
- **Routing:** Use the least-capable reliable available tier. Exact models and effort support remain unverified, so persist none.

| Work | Capability tier | Target effort when supported |
|---|---|---|
| Search, inventory, formatting, mechanical work | cheap/fast | `low` or `medium` |
| Implementation, tests, ordinary review | balanced | `medium` or `high` |
| Architecture, subtle debugging, security, migrations, final review | strongest | `high`, `xhigh`, or `max` |

Escalate after two failed correction attempts on the same finding, or when risk, complexity, or review evidence exceeds the chosen tier.

- **Task loop:** Implementer runs focused checks; independent specification review precedes independent quality review; allow at most two same-tier correction passes per finding before re-scoping or escalation.
- **Completion:** Run independent whole-change review and fresh `pnpm test` plus `pnpm lint` on the final tree. Remove only clean, owned, integrated worktrees.
- **Runtime targets:** No `.codex/agents/*.toml` or `.claude/agents/*.md`; the small documented workflow does not justify persistent runtime roles. `CLAUDE.md` stays thin.

**Rules:**

`AGENTS.md` will contain the workflow above plus:

```markdown
## Verification

Run from the repository root:

- `pnpm test`
- `pnpm lint`

Do not claim completion from earlier agent reports. Run both commands against the final working tree and report failures or skipped checks explicitly.
```

Existing stronger repository rules will be preserved if later inspection finds them.

**Optional installations:** `none`.

**Checks after any approved edit:**

- `pnpm test`
- `pnpm lint`
- Confirm `CLAUDE.md` resolves `@AGENTS.md`.
- Validate Markdown structure and workflow completeness.
- Confirm only approved files changed and existing dirty work remains intact.
- Check for conflicting effective instructions and likely credentials.

**Assumptions:** Commands run from the repository root; both runtimes are available, but their exact model and effort options are unverified.

**Exclusions:** No runtime agent files, plugins, skills, MCP configuration, dependencies, credentials, source changes, Git initialization, commits, or worktree cleanup. No files are written in this run.
~~~~

## Result

Pass. The proposal contains every labeled workflow component and full routing
matrix, keeps runtime configuration conditional, persists no unverified model
or effort value, keeps `CLAUDE.md` thin, and writes nothing before approval.
