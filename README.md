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
./install.sh --all
```

Restart the relevant agent after installation, then invoke it in a repository:

```text
$agent-workspace-setup
Prepare this repository for Codex and Claude Code.
```

```text
$agent-workspace-setup
Audit the existing AGENTS.md and CLAUDE.md, then propose minimal updates.
```

## Bootstrap or adopt

- **Bootstrap** is for a repository without agent instructions. The skill
  inspects its code, commands, and automation before proposing new files.
- **Adopt** is for a repository with instructions already. The skill preserves
  those rules, reports conflicts, and proposes only evidence-backed edits.

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
