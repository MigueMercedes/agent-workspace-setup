# Behavior evidence sets

Transcript files are append-only historical evidence. Their prompts, commands,
outputs, runtime labels, and outcomes are not rewritten after capture.

## Superseded set

The `red/` and `green/` transcripts indexed by the original
`tests/baselines.md` predate the final portability and invocation fixes. They
remain factual history but are superseded for current behavior claims.

## Current set

The v2 workflow evidence is keyed by this exact skill-tree hash:

```text
sha256: 4b7b5b8392adafeeab6245b5bb66da0dc44ca0d1f7f865255b0262b1adbd5f6f
```

- `current/workflow-contract-v2.md`: fresh RED run showing the old skill omitted
  the orchestration workflow.
- `current/workflow-contract-v2-green.md`: fresh GREEN run showing the updated
  skill produced the complete required workflow proposal.

The earlier approval-boundary evidence remains keyed by its original hash:

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
