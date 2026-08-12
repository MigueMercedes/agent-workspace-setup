# Verification

Verify each approved repository independently.

1. Check Markdown structure and any runtime configuration syntax with available
   native validators.
2. Resolve every local link and `@` import from the file that declares it.
3. Run the approved build, test, lint, or formatting commands in their recorded
   working directories. Record exit status and meaningful output.
4. Compare `git status` and `git diff` with the pre-edit audit. Confirm every
   changed file was approved, existing dirty changes remain, and ownership is
   correct.
5. Re-read instruction files in effective scope. Report duplicated or
   contradictory rules, or explicitly report `none`.
6. Check the effective workflow against [`workflow.md`](workflow.md): every
   required component exists, stronger pre-existing rules remain, runtime files
   use supported model/effort values, and `CLAUDE.md` stays thin.
7. Run focused task checks, independent task review, and whole-change review as
   approved. Then run fresh verification from the final working tree; earlier
   agent reports are evidence inputs, not completion proof.
8. Remove only owned, completed, and integrated worktrees that are clean.
   Preserve and report dirty, unmerged, foreign, or ambiguous worktrees.
9. Scan every generated tracked file and its diff for likely credentials:
   secret assignments, access tokens, passwords, private keys, authorization
   headers, and high-entropy values. Confirm sensitive settings use runtime
   references or redacted examples and report any scanner limitations.

The final report has two lists:

- **Verified:** check, command or method, repository, and result.
- **Unverified:** omitted or blocked check and the reason.

Do not turn an unrun command into an inferred success.

Completion criterion: all approved targets pass workflow, syntax, link,
ownership, contradiction, dirty-tree, and likely-secret checks; fresh commands
have evidence; every remaining check is explicitly unverified.
