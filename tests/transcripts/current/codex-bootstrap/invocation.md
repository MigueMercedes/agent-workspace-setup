# Exact invocations

Initial working directory: `/tmp/agent-workspace-setup-v2.yYoRCo`.

```bash
CODEX_HOME=/tmp/aws-v3-codex-home codex exec --skip-git-repo-check --json -C /tmp/aws-v3-codex-bootstrap-empty -o /tmp/aws-v3-codex-proposal.txt - < /tmp/aws-v3-codex-prompt.txt > /tmp/aws-v3-codex-proposal.raw.jsonl 2>&1
```

Approved-write working directory: `/tmp/aws-v3-codex-bootstrap-empty`.

```bash
CODEX_HOME=/tmp/aws-v3-codex-home codex exec resume 019ff8b6-d377-7000-94a9-b15ea1c04289 --skip-git-repo-check --dangerously-bypass-approvals-and-sandbox --json -o /tmp/aws-v3-codex-write.txt - < /tmp/aws-v3-codex-approval.txt > /tmp/aws-v3-codex-write.raw.jsonl 2>&1
```

The bypass disabled Codex's inner sandbox only inside the disposable fixture;
the outer managed environment remained scoped. Exact stdin is committed in
`prompt.txt` and `approval.txt`. Raw JSONL contains no secrets; no redaction was
needed.
