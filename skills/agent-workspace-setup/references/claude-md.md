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

List any such file as its own proposal target. A useful plugin, skill, or tool
is still optional installation and needs separate approval. Do not repeat
project policy from `AGENTS.md` in `CLAUDE.md` or configuration files.

Completion criterion: `CLAUDE.md` resolves its shared-policy import, contains
only Claude-specific instructions, and every Claude configuration target has a
repository-backed reason and approval.
