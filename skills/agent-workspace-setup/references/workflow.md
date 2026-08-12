# Adaptive Agentic Workflow

The setup must carry this workflow into each project, adapted without weakening
stronger existing rules. Put shared durable behavior in `AGENTS.md`; put native
runtime configuration in its native files only when supported, useful, and
approved.

## Orchestrator ownership

The orchestrator owns decomposition, routing, review, verification, and synthesis.
It keeps the task's requirements, approval boundaries, and final integration in
the main thread. Subagents return bounded results; they do not redefine scope or
declare the whole change complete.

## Delegation and isolation

- Keep trivial and small work in the orchestrator. Delegation must buy useful
  isolation, specialization, or parallelism.
- Delegate a bounded task with explicit inputs, allowed files, expected output,
  verification, and stop condition. Use a fresh implementer for each delegated
  implementation task when applicable; reuse only when continuity is essential.
- Parallelize only tasks with no dependency between them and non-overlapping files and mutable state.
  Serialize shared-file, migration, schema, generated
  artifact, and shared-environment work.
- Preserve user changes. Implementation agents work in an isolated worktree
  unless the runtime already provides equivalent isolation or the task is
  read-only.

## Adaptive routing

First inspect the runtime's effective model list, account/provider restrictions,
existing agent definitions, and supported effort levels. Use the least capable available tier that can reliably complete the task.
Never write an unverified
model identifier or effort value into project configuration.

| Work | Capability tier | Target effort when supported |
|---|---|---|
| Search, inventory, formatting, other mechanical bounded work | cheap/fast | `low` or `medium` |
| Normal implementation, tests, and ordinary review | balanced | `medium` or `high` |
| Architecture, subtle debugging, security, migrations, and final review | strongest | `high`, `xhigh`, or `max` where supported |

The effort labels are routing targets, not proof of runtime support. When the
effective runtime cannot be inspected, record model and effort availability as
`unverified` and persist no exact model identifier or effort value in generated
policy or configuration.

Escalate when the same point fails twice, evidence exposes greater risk or
complexity, or review shows the chosen tier is unreliable. Escalation can mean
narrower scope, stronger model, higher supported effort, or a different agent.

Codex examples are conditional: use `gpt-5.6-luna`, `gpt-5.6-terra`, or
`gpt-5.6`/Sol only when the current Codex runtime exposes them. Official Codex
documentation confirms project custom agents in `.codex/agents/*.toml` and the
`model` plus `model_reasoning_effort` fields:
https://developers.openai.com/codex/multi-agent

Claude Code project subagents live in `.claude/agents/*.md`. Current official
frontmatter supports `model`, `effort`, and `isolation: worktree`; supported
model aliases include `haiku`, `sonnet`, `opus`, `fable`, and `inherit`, subject
to the effective provider/account allowlist. Verify availability before choosing
one:
https://code.claude.com/docs/en/sub-agents
https://code.claude.com/docs/en/model-config

## Review, fix, and completion

For each delegated implementation task:

1. The implementer makes the bounded change and runs focused checks.
2. An independent specification reviewer checks requirement compliance. Then
   an independent quality reviewer checks code quality, security, and test
   evidence. Together these stages cover specification compliance and code quality.
   The implementer does not review its own work.
3. Return findings to the implementer through a bounded fix loop: at most two
   correction passes for the same finding at the same routing tier, then
   re-scope or escalate.
4. After all task reviews pass, run an independent whole-change review across
   interactions between tasks.
5. The orchestrator synthesizes results and performs fresh verification against
   the final working tree before claiming completion.

After integration, remove only owned, completed, and integrated worktrees that
are clean and no longer needed. Preserve dirty, unmerged, foreign, or ambiguous
worktrees and report them instead.

## Runtime targets

The proposal must say whether native project agent files add value:

- **Codex:** propose `.codex/agents/*.toml` only after verifying local support
  and exact model/effort availability. Name each role, model, effort, sandbox,
  and reason. Otherwise keep routing as durable `AGENTS.md` instructions and
  state that no Codex agent files are needed.
- **Claude Code:** keep `CLAUDE.md` thin and importing `AGENTS.md`. Propose
  `.claude/agents/*.md` only when repeated project roles justify them; name each
  role, supported model alias or ID, supported effort, isolation, and reason.
  Otherwise state that no Claude subagent files are needed.

Runtime files are never copied across runtimes. Third-party skills, plugins,
MCP servers, downloads, and credential-dependent setup stay in the separate
installation approval.

Completion criterion: the proposal's **Workflow** section accounts for every
heading above, preserves stronger existing policy, and names only capabilities
verified in the target runtime.
