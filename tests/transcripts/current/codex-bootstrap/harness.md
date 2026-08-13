# External harness evidence

Before Codex:

```bash
mkdir /tmp/aws-v3-codex-bootstrap-empty
/tmp/agent-workspace-setup-v2.yYoRCo/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-v3-codex-bootstrap-empty
find /tmp/aws-v3-codex-bootstrap-empty -mindepth 1 -maxdepth 1 -print
git -C /tmp/aws-v3-codex-bootstrap-empty status --short
```

The inspector stdout is `inspector.harness.txt`. `find` printed nothing. Git
printed `fatal: not a git repository (or any of the parent directories): .git`.
Thus baseline file set was empty and Git status/hash were not applicable.

After Codex:

```bash
find /tmp/aws-v3-codex-bootstrap-empty -maxdepth 2 -type f -print | sort
sha256sum AGENTS.md CLAUDE.md
python3 /tmp/agent-workspace-setup-v2.yYoRCo/skills/agent-workspace-setup/scripts/validate-generated.py /tmp/aws-v3-codex-bootstrap-empty
```

Exact output:

```text
/tmp/aws-v3-codex-bootstrap-empty/AGENTS.md
/tmp/aws-v3-codex-bootstrap-empty/CLAUDE.md
7a5edebf575bfa08bc20c3604ee4c8bd9bd63c52013e24467ca85ca73d5d97d8  AGENTS.md
336cc4fbf19beaada7ccf9986414fa91851a8d7a07dfb3ccbe800a69eed0ab49  CLAUDE.md
generated artifacts: ok
```

These are harness checks. Codex's own checks are separately reported in
`write-response.md` and raw events.
