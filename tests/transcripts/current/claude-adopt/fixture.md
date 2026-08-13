# Exact disposable fixture

```bash
fixture=/tmp/aws-v2-claude-adopt-r2
mkdir "$fixture"
cd "$fixture"
git init -b main
```

Create `AGENTS.md` from `artifacts/AGENTS.baseline.md`, create `CLAUDE.md` with
exactly `@AGENTS.md`, create `user-notes.txt` with `baseline note`, and create:

```json
{"scripts":{"test":"node -e \"process.exit(0)\"","lint":"node -e \"process.exit(0)\""}}
```

as `package.json`. Then:

```bash
git add AGENTS.md CLAUDE.md package.json user-notes.txt
git -c user.name=Fixture -c user.email=fixture@example.invalid commit -m baseline
mkdir -p .claude/skills
cp -R skills/agent-workspace-setup .claude/skills/agent-workspace-setup
printf '%s\n' 'private uncommitted user work' >> user-notes.txt
```

The recorded baseline commit is
`59e99cee9b7ba93e1832630690ca8cbacd00c643`; rebuilding produces a different
commit timestamp/hash unless the original Git dates are also supplied, but the
tracked and dirty file contents are exact.
