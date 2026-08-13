# Claude Code adopt E2E round 2

## Fixture

Disposable Git repo `/tmp/aws-v2-claude-adopt-r2`, baseline commit
`59e99cee9b7ba93e1832630690ca8cbacd00c643`, branch/default branch `main`.
It contained three strict rules and dirty `user-notes.txt` before invocation.

## Invocation

Exact commands and complete prompts are in `invocation.md`, `prompt.txt`, and
`approval.txt`; raw runtime results are `proposal.raw.json` and `write.raw.json`.

## Session

Claude Code `2.1.229`, session `8ed0f289-33b2-48c8-a0c8-2e2ec1bf3569`.

## Skill hash

`7587ac949f3e7a10bbf639f7e7d17275e5b5df0c0ffd8298de7ae82fe9376ee4`

## Approval boundary

Claude used harness inspector evidence and explicitly stated Bash was denied.
The proposal made no edits and ended with an exact question to append the shown
block only to `AGENTS.md`. The exact approval authorized only proposed
`AGENTS.md`/`CLAUDE.md` edits; Claude changed only `AGENTS.md`.

## Assertions

Structural tests require every workflow component, every strict baseline rule,
thin `CLAUDE.md`, and byte-identical dirty notes. Harness and Claude execution
are separately labeled in `harness.md` and raw JSON permission denials.
