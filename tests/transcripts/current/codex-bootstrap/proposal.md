**Route:** `bootstrap` for `/tmp/aws-v2-codex-bootstrap.k33P2o`.

**Evidence:** The required project inspector reported:

- Directory is inspectable and empty.
- Git repository: none; branch, HEAD, worktree, and dirty state are not applicable.
- Existing `AGENTS.md`, `CLAUDE.md`, scoped instructions, native agent definitions, manifests, automation, and documented commands: none.
- Existing rules, stronger policies, overlaps, and conflicts: none.
- Locally installed runtimes:
  - Codex CLI `0.147.0`
  - Claude Code `2.1.229`
- Effective model allowlists and supported reasoning-effort values were not proven by the inspection and remain `unverified`.

No files or configuration have been changed.

**Targets:** Create exactly these two files:

- `/tmp/aws-v2-codex-bootstrap.k33P2o/AGENTS.md`
- `/tmp/aws-v2-codex-bootstrap.k33P2o/CLAUDE.md`

No existing files would be edited.

**Workflow:**

- **Orchestrator:** `AGENTS.md` will make the main agent responsible for requirements, approval boundaries, decomposition, routing, review, verification, synthesis, and final integration. Delegated agents cannot redefine scope or declare the whole task complete.

- **Delegation:** Trivial and small tasks stay with the orchestrator. Delegation requires a bounded contract stating inputs, permitted files, expected output, checks, stop condition, validated base commit, and dependencies. Use a fresh implementer where applicable. Parallel work is limited to independent tasks with non-overlapping files and mutable state. Shared-file, schema, migration, generated-artifact, and shared-environment changes are serialized. User changes must be preserved. Worktree isolation is allowed only from a verified dependency-complete base; otherwise the orchestrator creates an explicit worktree from that base.

- **Routing:** Installed runtime versions are verified, but effective models and effort values are `unverified`. Therefore, no exact model or effort value will be persisted.

  | Work | Capability tier | Runtime selection |
  |---|---|---|
  | Search, inventory, formatting, and mechanical bounded work | Lowest supported | Cheapest/fastest verified model and low-cost supported effort |
  | Normal implementation, tests, and ordinary review | Balanced/default | Runtime default or verified balanced model and effort |
  | Architecture, subtle debugging, security, migrations, and final review | Highest justified supported | Strongest verified model and deepest justified supported reasoning |

  Escalation occurs after the same point fails twice, evidence reveals higher risk or complexity, or review demonstrates that the current tier is unreliable. Escalation may narrow scope, select a stronger verified capability, increase supported reasoning, or assign a different agent.

- **Task loop:** An implementer runs focused checks. An independent specification reviewer then checks requirement compliance, followed by an independent quality reviewer covering quality, security, and test evidence. A finding receives no more than two correction passes at the same tier before re-scoping or escalation.

- **Completion:** After task-level reviews pass, an independent whole-change review checks interactions. The orchestrator performs fresh verification against the final working tree. Cleanup removes only owned, clean, completed, integrated worktrees; dirty, unmerged, foreign, or ambiguous worktrees are preserved and reported.

- **Runtime targets:**
  - **Codex:** No `.codex/agents/*.toml` files proposed. The empty project has no repeated specialist roles that justify native agents, and exact model/effort support is unverified.
  - **Claude Code:** `CLAUDE.md` will remain thin and import `AGENTS.md`. No `.claude/agents/*.md` files are proposed because no repeated project roles have been established.
  - Runtime-specific files will not be copied between Codex and Claude.

**Rule preservation:** There are no existing rules to retain, replace, or reconcile. Future repository-specific rules that are stronger than this baseline must be preserved; replacement would require an equivalent or stronger approved rule.

**Rules:**

Shared policy proposed for `AGENTS.md`:

- Inspect repository evidence before acting.
- Preserve user-authored and unrelated changes.
- Keep the orchestrator responsible for scope and integration.
- Delegate only when isolation, specialization, or safe parallelism provides value.
- Require bounded delegation contracts and dependency-complete bases.
- Serialize overlapping files and shared mutable state.
- Never persist unverified model identifiers or effort values.
- Apply the three-tier semantic routing matrix and bounded escalation rules.
- Require focused verification, independent specification review, independent quality review, and whole-change review in proportion to task risk.
- Limit repeated correction loops to two passes at the same tier.
- Perform fresh final verification before claiming completion.
- Clean up only owned, clean, integrated worktrees.
- Derive build, test, lint, and formatting commands from future project evidence rather than inventing them.

Claude-only addition proposed for `CLAUDE.md`:

```md
# Claude Code

@AGENTS.md
```

This keeps policy shared and avoids divergence.

**Optional installations:** `none`. No plugin, skill, MCP server, download, credential, runtime configuration, or Git initialization is proposed.

**Checks:** After edit approval, I would run:

```sh
test -f AGENTS.md
test -f CLAUDE.md
sed -n '1,260p' AGENTS.md
sed -n '1,80p' CLAUDE.md
python3 /tmp/aws-v2-codex-home/skills/agent-workspace-setup/scripts/validate-generated.py /tmp/aws-v2-codex-bootstrap.k33P2o
/tmp/aws-v2-codex-home/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-v2-codex-bootstrap.k33P2o
```

Document checks will confirm that all workflow sections are represented, `CLAUDE.md` imports `AGENTS.md`, no exact model/effort values were introduced, no native agent files appeared, and no unrelated files changed.

**Assumptions:**

- This directory is the sole repository boundary in scope.
- The desired result is a runtime-neutral workflow baseline, not application scaffolding.
- Git initialization may happen later but is not authorized now.
- Native project agents should be introduced only when real project roles and verified runtime capabilities justify them.

**Exclusions:**

- Git initialization and Git configuration.
- Application code, manifests, CI, tests, documentation, licenses, and ignore files.
- `.codex/agents/*.toml` and `.claude/agents/*.md`.
- Plugins, MCP servers, skills, downloads, credentials, and runtime/account settings.
- Model or effort pinning.
- Any file other than `AGENTS.md` and `CLAUDE.md`.

Do you approve creating exactly `AGENTS.md` and `CLAUDE.md` in `/tmp/aws-v2-codex-bootstrap.k33P2o` according to this proposal?