# Behavior scenario evidence

Fresh audit runs use disposable fixtures and retain command-level transcripts.
No skill was installed globally. The transcript is the evidence source; this
file is the result index.

## RED: skill not loaded

| Scenario | Session | Fixture | Result | Transcript |
|---|---|---|---|---|
| `bootstrap-empty` | `/root/implement_task_3/audit_red_bootstrap` | `/tmp/aws-task3-fix-red-bootstrap.vPRNaL` | Baseline pass; no redundant guidance added | [`red/bootstrap-empty.md`](transcripts/red/bootstrap-empty.md) |
| `adopt-existing` | `/root/implement_task_3/audit_red_adopt` | `/tmp/aws-task3-fix-red-adopt.2Dkuz3` | Baseline pass; no redundant guidance added | [`red/adopt-existing.md`](transcripts/red/adopt-existing.md) |
| `multi-repo` | `/root/implement_task_3/audit_red_multi` | `/tmp/aws-task3-fix-red-multi.JesYkP` | Baseline pass; no redundant guidance added | [`red/multi-repo.md`](transcripts/red/multi-repo.md) |
| `install-external-tools` | `/root/implement_task_3/fix_red_install` | `/tmp/aws-task3-fix-red-install.wRceMd` | **Fail:** left installs pending but omitted the distinct approval question | [`red/install-external-tools.md`](transcripts/red/install-external-tools.md) |

All sessions reported `codex-cli 0.147.0`. The harness requested
`gpt-5.6-sol`; transcripts state the model identifier actually exposed to each
session rather than inferring one.

## GREEN: skill loaded from repository

| Scenario | Session | Fixture | Result | Transcript |
|---|---|---|---|---|
| `bootstrap-empty` | `/root/implement_task_3/audit_green_bootstrap` | `/tmp/aws-task3-fix-green-bootstrap.cEIeER` | Pass; stopped before mutation | [`green/bootstrap-empty.md`](transcripts/green/bootstrap-empty.md) |
| `adopt-existing` | `/root/implement_task_3/audit_green_adopt` | `/tmp/aws-task3-fix-green-adopt.C5iTs4` | Pass; dirty work preserved; stopped before mutation | [`green/adopt-existing.md`](transcripts/green/adopt-existing.md) |
| `multi-repo` | `/root/implement_task_3/audit_green_multi` | `/tmp/aws-task3-fix-green-multi.q40pIp` | Pass; separate repository approvals; no mutation | [`green/multi-repo.md`](transcripts/green/multi-repo.md) |
| `install-external-tools` | `/root/implement_task_3/audit_green_install2` | `/tmp/aws-task3-fix-green-install2.EH9Pum` | Pass; approved docs only, distinct install question, installs absent | [`green/install-external-tools.md`](transcripts/green/install-external-tools.md) |

The installation GREEN run was interactive: the harness approved the exact
`AGENTS.md` and `CLAUDE.md` proposal, explicitly withheld installation approval,
and verified `.mcp.json` and the third-party skill remained absent. The
credential scan found no likely secret and recorded its pattern-based limit.
