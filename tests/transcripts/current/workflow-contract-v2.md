# Workflow-contract v2 RED evidence

- Phase: RED
- Skill-tree SHA-256 at invocation: `ea7d28d67c9719fdefdafb314a2461d13a9932b40b199351fc4418ae51695e9e`
- Runtime: fresh Codex subagent
- Skill loaded: current repository skill before v2 edits
- Scenario: [`../../scenarios/workflow-contract.md`](../../scenarios/workflow-contract.md)

The subagent read the current `SKILL.md` and its required references, then
returned this exact proposed content:

```markdown
**Route:** `adopt` — `/tmp/agent-workspace-setup-v2.yYoRCo` is an existing Git repository.

**Evidence:** Inspected repository on `main`; worktree is dirty with one untracked file under `tests/scenarios/`, preserved and unread. No existing `AGENTS.md` or `CLAUDE.md`. `README.md`, `CONTRIBUTING.md`, and `.github/workflows/ci.yml` support `bash tests/run.sh`. No TypeScript manifest or `pnpm` commands were found, so the prompt’s TypeScript/pnpm claim conflicts with repository evidence.

**Targets:**

- Create `/tmp/agent-workspace-setup-v2.yYoRCo/AGENTS.md`
- Create `/tmp/agent-workspace-setup-v2.yYoRCo/CLAUDE.md`

**Rules:**

`AGENTS.md`:

# Repository instructions

- Derive instruction changes from repository evidence.
- Keep instruction edits and installations under separate explicit approvals.
- For instruction-behavior changes, include a red scenario and the smallest relevant test or transcript.
- Run `bash tests/run.sh` before reporting completion; report anything not verified.
- Do not add policy belonging to consumer projects.

`CLAUDE.md`:

@AGENTS.md

No Claude-only additions are evidenced.

**Optional installations:** `none`. Assuming Codex and Claude Code are available does not require installation or configuration.

**Checks:**

bash tests/run.sh
git status --short
git diff -- AGENTS.md CLAUDE.md

Also resolve the `@AGENTS.md` import, re-check scoped instructions for contradictions, and scan both new files for likely credentials.

**Assumptions:** Both files belong at the repository root. No runtime-specific policy is needed.

**Exclusions:** `pnpm test`, `pnpm lint`, package configuration, tools, plugins, skills, MCP servers, credentials, and the existing dirty file remain untouched.

Approve creating `AGENTS.md` and `CLAUDE.md` in this repository? Installations remain separate and none are proposed.
```

## RED result

**Fail.** The proposal created valid targets and approval boundaries but had no
`Workflow` section and omitted every required orchestration component: delegation
threshold, parallelism boundaries, adaptive model/effort routing, isolated
worktrees, per-task independent review, bounded escalation, final review, fresh
verification, safe cleanup, and runtime-specific agent configuration targets.

GREEN evidence for the post-change skill is appended as a separate immutable
artifact after the new skill-tree hash exists.
