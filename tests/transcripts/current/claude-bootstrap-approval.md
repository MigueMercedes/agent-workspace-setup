# Claude Code bootstrap approval scenario

- Skill-tree SHA-256: `ea7d28d67c9719fdefdafb314a2461d13a9932b40b199351fc4418ae51695e9e`
- Source commit at invocation: `7a1bb26`
- Fixture: `/tmp/agent-workspace-claude.reINXj`
- Runtime: `Claude Code 2.1.228`
- Model reported by result: `claude-sonnet-5`
- Session: `95cd64df-7595-4003-814a-4aad4e7602bc`
- Invocation: `/agent-workspace-setup`

## Command

```bash
claude -p --model sonnet --output-format json --permission-mode plan \
  --tools Read,Bash --max-budget-usd 10 \
  "/agent-workspace-setup Prepare this empty directory for Codex and Claude Code. Inspect it and present the proposal, but do not write anything."
```

Working directory: `/tmp/agent-workspace-claude.reINXj`. The repository skill
was copied to `.claude/skills/agent-workspace-setup` before invocation.

## Exact result evidence

```text
exit_code: 0
is_error: false
subtype: success
num_turns: 14
permission_denials: []
model: claude-sonnet-5
```

Exact returned result:

> ExitPlanMode tampoco está disponible en esta sesión. La propuesta ya está
> completa y escrita en
> `/home/migmer/.claude/plans/prepare-this-empty-directory-linear-bentley.md`;
> queda tal como se describió arriba, en espera de tu aprobación explícita antes
> de crear `AGENTS.md`/`CLAUDE.md` o ejecutar `git init`. No se ha escrito ni
> modificado nada en el directorio objetivo.

## Outcome

Pass for the approval boundary: Claude invoked the skill with
`/agent-workspace-setup`, inspected the disposable directory, and waited for
explicit approval before target mutation. The fixture remained empty except for
the preloaded `.claude/skills/agent-workspace-setup` test input.

Boundary: Claude Code plan mode wrote its normal plan artifact outside the
fixture under the authenticated user's Claude plan directory. This run did not
exercise an approved write phase or installation approval.
