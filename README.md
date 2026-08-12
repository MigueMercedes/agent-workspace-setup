# Agent Workspace Setup

Bring a proven multi-agent engineering workflow to any repository, adapted to
the Codex and Claude Code capabilities actually available there.

The skill makes the orchestrator own decomposition, adaptive model/effort
routing, independent review, synthesis, and fresh verification. It delegates
only bounded work, parallelizes only non-overlapping tasks, isolates
implementation in worktrees, escalates repeated failures, and safely removes
only completed integrated worktrees. It inspects first so adoption preserves
stronger local rules and never invents unavailable models.

The shared workflow is written to `AGENTS.md`; `CLAUDE.md` remains a thin
Claude-specific import. When justified and approved, the proposal can add
native project agents under `.codex/agents/*.toml` or
`.claude/agents/*.md`—never by copying one runtime's configuration into the
other.

Official runtime references:

- [Codex subagents and project custom-agent configuration](https://developers.openai.com/codex/multi-agent)
- [OpenAI model and reasoning guidance](https://developers.openai.com/api/docs/guides/latest-model)
- [Claude Code custom subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code models and effort levels](https://code.claude.com/docs/en/model-config)

## Use it

Supported runtimes: **Codex** and **Claude Code**.

```bash
git clone https://github.com/MigueMercedes/agent-workspace-setup.git
cd agent-workspace-setup
./install.sh
```

With no selector, the installer detects available Codex and Claude runtimes,
previews their exact destinations, and asks once before installing. Use
`--codex`, `--claude`, or `--all` to select explicitly.

Restart the relevant agent after installation, then invoke it in a repository:

Codex:

```text
$agent-workspace-setup
Prepare this repository for Codex and Claude Code.
```

Claude Code:

```text
/agent-workspace-setup
Audit the existing AGENTS.md and CLAUDE.md, then propose minimal updates.
```

Claude Code discovers personal skills under `~/.claude/skills/` and invokes a
named skill with `/skill-name`; see the official
[Claude Code skills documentation](https://code.claude.com/docs/en/skills).

## Bootstrap or adopt

- **Bootstrap** is for a new or nearly empty directory that is not yet an
  existing Git repository.
- **Adopt** is for any existing repository, including one without agent
  instructions. The skill preserves current work, reports conflicts, and
  proposes only evidence-backed edits.

## Generated workflow

Every proposal contains a required **Workflow** section covering:

- when the orchestrator works directly and when it delegates;
- which tasks may run in parallel;
- cheap/fast, balanced, and strongest model/effort tiers, using only available
  runtime values;
- isolated implementer work, independent specification and quality review, a
  bounded fix/escalation loop, and final whole-change review;
- fresh final verification and conservative worktree cleanup;
- whether native Codex or Claude project-agent files are actually needed.

## Approval boundaries

Inspection and a proposal do not authorize edits. Approve the exact proposed
document changes separately for each repository. Installing a skill, MCP
server, plugin, or other tool is a different action and requires a separate
explicit approval naming its targets and credential source.

Before:

```text
"Use our preferred CI commands and add every useful integration."
```

After:

```text
Route: adopt
Targets: AGENTS.md, CLAUDE.md
Checks: pnpm test, pnpm lint
Edit approval for this repository? Installations remain pending.
```

## Update

```bash
git pull --ff-only
./install.sh --all
```

Use `--codex` or `--claude` to install for one runtime. The installer prints
the target and asks before replacing an existing skill; use `--dry-run` to
inspect targets or `--yes` only when replacement is already approved.

## Verify

```bash
bash tests/run.sh
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution rules. Released under
the [MIT License](LICENSE).
