# Behavior evidence sets

The `red/` and `green/` directories are historical evidence indexed by
`tests/baselines.md`; they do not support current behavior claims.

## Current set

Current evidence is keyed by skill-tree SHA-256
`5924650756e3af5379f461ca6aaf5aae55a8323df946df4d740ef0019d7026cb`, produced by:

```bash
find skills/agent-workspace-setup -type f -print0 | sort -z |
  xargs -0 sha256sum | sha256sum
```

- `current/codex-bootstrap/`: authenticated Codex proposal, exact approval,
  generated files, inspector evidence, invocation, and session identifier.
- `current/claude-adopt/`: authenticated Claude Code adoption preserving
  stricter rules and a dirty user file, with artifacts and state assertions.

Add a new immutable artifact set when the skill-tree hash changes.
