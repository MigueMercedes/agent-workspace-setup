# Behavior evidence sets

The `red/` and `green/` directories are historical evidence indexed by
`tests/baselines.md`; they do not support current behavior claims.

## Current set

Evidence records the skill-tree SHA-256 used by each runtime invocation, produced by:

```bash
find skills/agent-workspace-setup -type f -print0 | sort -z |
  xargs -0 sha256sum | sha256sum
```

- `current/codex-bootstrap/` (`7587ac949f3e7a10bbf639f7e7d17275e5b5df0c0ffd8298de7ae82fe9376ee4`): authenticated Codex proposal, exact approval,
  generated files, inspector evidence, invocation, and session identifier.
- `current/claude-adopt/` (`7587ac949f3e7a10bbf639f7e7d17275e5b5df0c0ffd8298de7ae82fe9376ee4`): authenticated Claude Code adoption preserving
  stricter rules and a dirty user file, with artifacts and state assertions.

Add a new immutable artifact set when the skill-tree hash changes.
