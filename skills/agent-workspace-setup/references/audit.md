# Audit and Routing

Run the inspector once per repository root. Then read only sources needed to
validate its facts: existing agent files, `git status` and relevant diffs,
manifests, documented commands, automation, and short project documentation.
Audit existing orchestration policy and native definitions under
`.codex/agents/` and `.claude/agents/`, including their model, effort, isolation,
review, escalation, verification, and worktree-cleanup rules.

## Route

- `bootstrap`: a new or nearly empty directory that is not yet an existing Git
  repository.
- `adopt`: any existing Git repository, code, project content, instruction file,
  or established workflow. Adoption does not require prior agent instructions.

For a parent with nested or sibling repositories, map every Git root. Treat
each root as a separate mutation boundary even when the repositories form one
product. Put truly shared rules at their common policy owner; put repository
deltas in that repository only.

## Evidence record

For each root, record:

- path, route, branch, and clean or dirty state;
- existing `AGENTS.md`, `CLAUDE.md`, and scoped instruction files;
- commands supported by manifests, automation, or current documentation;
- overlap and contradictions between instruction sources, or `none`;
- existing delegation workflow, runtime capabilities actually observed, and
  stronger rules that the proposal must preserve;
- exact targets and which repository owns each target.

Label repository-derived statements as **facts**. Label proposed conventions,
tool choices, and unresolved interpretations as **decisions** or
**assumptions**. Broad setup language does not authorize edits. A dirty tree is
evidence to preserve and review, never permission to replace.

Completion criterion: every repository has a route, evidence sources, dirty
and conflict status, ownership boundary, and exact proposed targets.
