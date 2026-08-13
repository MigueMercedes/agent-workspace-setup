# External harness evidence

These commands were run by the external harness, not Claude Code.

Before Claude proposal:

```bash
/tmp/agent-workspace-setup-v2.yYoRCo/skills/agent-workspace-setup/scripts/inspect-project.sh /tmp/aws-v2-claude-adopt-r2
sha256sum AGENTS.md CLAUDE.md user-notes.txt
git status --short
```

The exact inspector stdout is `inspector.harness.txt`. Baseline hashes:

```text
a8ec8cea035486ef15188975a5c63d28953b636f230daea5521bd54655a4b49b  AGENTS.md
336cc4fbf19beaada7ccf9986414fa91851a8d7a07dfb3ccbe800a69eed0ab49  CLAUDE.md
13f8d94cfd4e721fdfad78d86ed7021a25bfdcc1638449ae17bd4f380917fc95  user-notes.txt
 M user-notes.txt
?? .claude/
```

After Claude write:

```bash
sha256sum AGENTS.md CLAUDE.md user-notes.txt
git status --short
python3 /tmp/agent-workspace-setup-v2.yYoRCo/skills/agent-workspace-setup/scripts/validate-generated.py .
npm test
npm run lint
```

Exact results:

```text
ebeb74e493f345f7e131a5be9a06653df96a8db49749ea6a3c27652c2a93345b  AGENTS.md
336cc4fbf19beaada7ccf9986414fa91851a8d7a07dfb3ccbe800a69eed0ab49  CLAUDE.md
13f8d94cfd4e721fdfad78d86ed7021a25bfdcc1638449ae17bd4f380917fc95  user-notes.txt
 M AGENTS.md
 M user-notes.txt
?? .claude/
generated artifacts: ok

> test
> node -e "process.exit(0)"

> lint
> node -e "process.exit(0)"
```

Both npm scripts are fixture no-ops; exit 0 proves execution, not coverage.
