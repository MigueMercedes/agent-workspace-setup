# Agent Workspace Setup

Set up repository-specific instructions for Codex and Claude Code from the
repository's own evidence—without copying rules from another project.

Prompts and hand-written templates drift: a generic setup can overwrite local
conventions, miss existing automation, or install tools without a clear
approval boundary. This skill inspects first, then proposes the smallest
repository-scoped change.

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
