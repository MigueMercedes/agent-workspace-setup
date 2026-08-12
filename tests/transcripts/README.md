# Behavior evidence sets

Transcript files are append-only historical evidence. Their prompts, commands,
outputs, runtime labels, and outcomes are not rewritten after capture.

## Superseded set

The `red/` and `green/` transcripts indexed by the original
`tests/baselines.md` predate the final portability and invocation fixes. They
remain factual history but are superseded for current behavior claims.

## Current set

Current evidence is keyed by the exact skill-tree hash:

```text
sha256: ea7d28d67c9719fdefdafb314a2461d13a9932b40b199351fc4418ae51695e9e
```

The hash is produced by:

```bash
find skills/agent-workspace-setup -type f -print0 | sort -z |
  xargs -0 sha256sum | sha256sum
```

- `current/claude-bootstrap-approval.md`: actual Claude Code `/agent-workspace-setup`
  run against a disposable empty directory.

Any later skill-tree hash supersedes this current set; add a new immutable
artifact rather than editing the old one.
