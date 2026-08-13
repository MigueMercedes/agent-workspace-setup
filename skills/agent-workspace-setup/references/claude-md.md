# CLAUDE.md and Claude Code Configuration

Use `CLAUDE.md` as a thin Claude Code entrypoint. Import shared policy instead
of repeating it:

```markdown
@AGENTS.md

# Claude Code

[Only justified Claude Code instructions]
```

Use a relative import that resolves from `CLAUDE.md`. Add Claude-only
instructions only when repository evidence requires behavior not shared with
other agents.

Put enforceable Claude Code configuration in its native owner:

- permissions, hooks, environment, and enabled plugins:
  `.claude/settings.json`;
- personal untracked overrides: `.claude/settings.local.json`;
- project subagents: `.claude/agents/*.md`;
- project skills: `.claude/skills/<name>/SKILL.md`;
- MCP tool connections: `.mcp.json`.

The proposal must explicitly decide whether `.claude/agents/*.md` are needed.
When needed, each file has required `name`, `description`, and a non-empty
Markdown prompt body; list supported `model`, supported `effort`, tools or
permissions, isolation, and project evidence. Claude native `isolation:
worktree` starts from the default branch, so use it only when that branch is the
recorded task base. Otherwise create an explicit worktree from the validated
parent commit and launch Claude inside it without native isolation. When agent
files add no value over built-in delegation plus `AGENTS.md`, state that none
are needed. Use only values verified against the effective Claude Code runtime;
current syntax is documented at
https://code.claude.com/docs/en/sub-agents and model availability at
https://code.claude.com/docs/en/model-config.

Classify any file or action that installs, downloads, enables, registers, or
configures a third-party tool, plugin, skill, or MCP server as a pending
installation target. This includes `.mcp.json`, plugin entries in settings, and
downloaded project skills. Ordinary document-edit approval cannot authorize
these targets; list them in the distinct installation-approval question.

Tracked configuration contains environment-variable references or redacted
example values only. Never put tokens, passwords, private keys, or other
credentials in `.claude/settings.json`, `.mcp.json`, skills, or instructions.
Keep credentials in the runtime's secure store, CI secret store, or a manual
untracked local configuration. For Claude MCP configuration, use `${VAR}`
runtime expansion instead of a value.

Do not repeat project policy from `AGENTS.md` in `CLAUDE.md` or configuration
files.

Run `scripts/validate-generated.py <repository>` before presenting native agent
files for approval and again during verification.

Completion criterion: `CLAUDE.md` resolves its shared-policy import, contains
only Claude-specific instructions, the proposal explicitly accounts for Claude
subagent files, and every Claude configuration target has a repository-backed
reason, the correct approval class, supported model/effort values, and no
credential value.
