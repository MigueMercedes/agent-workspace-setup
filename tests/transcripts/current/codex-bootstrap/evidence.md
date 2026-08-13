# Codex bootstrap E2E

## Fixture

Disposable empty directory `/tmp/aws-v2-codex-bootstrap.k33P2o`. Initial
inventory was empty. Codex CLI was `0.147.0`. The skill was copied into
`CODEX_HOME=/tmp/aws-v2-codex-home`; no global installation occurred.

## Invocation

Proposal: `CODEX_HOME=/tmp/aws-v2-codex-home codex exec --skip-git-repo-check --json -C /tmp/aws-v2-codex-bootstrap.k33P2o -o /tmp/aws-v2-codex-proposal.txt '<bootstrap prompt>'`.

Approved write: `codex exec resume 019ff849-fdf6-7801-9095-6f33dfbc9a85 ... '<exact approval>'`.
The first write was blocked by Codex's read-only inner sandbox; the same session
was resumed without it inside the disposable, externally sandboxed fixture.

## Session

`019ff849-fdf6-7801-9095-6f33dfbc9a85`. Proposal and final response are stored
beside this file. Raw JSONL was captured at `/tmp/aws-v2-codex-*.jsonl`.

## Skill hash

`5924650756e3af5379f461ca6aaf5aae55a8323df946df4d740ef0019d7026cb`

## Approval boundary

Before approval the fixture remained empty. The proposal asked to create exactly
`AGENTS.md` and `CLAUDE.md`; after approval only those files existed.

Reproduce the source state with `fixture=$(mktemp -d)` and run
`scripts/inspect-project.sh "$fixture"`. The proposal contains the captured
initial facts and ends with the exact edit-approval question; the exact
post-write inspector output is `inspector-output-after.txt`.

## Assertions

`validate-generated.py` returned `generated artifacts: ok`; the artifact test
reruns it and checks the durable workflow plus thin Claude import.
