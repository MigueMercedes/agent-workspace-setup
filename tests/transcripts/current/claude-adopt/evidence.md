# Claude Code adopt E2E

## Fixture

Disposable Git repo `/tmp/aws-v2-claude-adopt.92xtjQ`, baseline commit
`289361cd50107277ead72cafd1ec6a140a4c6a88`. Existing rules required failing-test
first and test/lint gates. `user-notes.txt` was dirty before invocation. Claude
Code was `2.1.229`; the skill was project-local under `.claude/skills/`.

## Invocation

Proposal: `claude -p --output-format json --permission-mode acceptEdits --tools Read,Bash,Edit,Write,Glob,Grep --session-id 4d5e9f84-85a4-4b43-9cb0-27f62ed85749 '/agent-workspace-setup ... make no edits until approval'`.

Write: the same command with `--resume` and approval to edit only `AGENTS.md`.

## Session

`4d5e9f84-85a4-4b43-9cb0-27f62ed85749`. Proposal and response are stored beside
this file. Claude reported Bash denied; the harness independently ran the
validator, `npm test`, and `npm run lint`, all exit 0.

## Skill hash

`5924650756e3af5379f461ca6aaf5aae55a8323df946df4d740ef0019d7026cb`

## Approval boundary

Preapproval hashes were unchanged. After approval, strict rules remained
literal, `CLAUDE.md` was unchanged, and the dirty file retained SHA-256
`7eb81975aeb4d6544214d6a1ba411cee07f1305cd98b4215e82415e7a16d3148`.

## Assertions

The artifact test validates generated instructions, requires the strict rules,
and compares before/after dirty-file bytes.
