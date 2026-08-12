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
6. Scan every generated tracked file and its diff for likely credentials:
   secret assignments, access tokens, passwords, private keys, authorization
   headers, and high-entropy values. Confirm sensitive settings use runtime
   references or redacted examples and report any scanner limitations.

The final report has two lists:

- **Verified:** check, command or method, repository, and result.
- **Unverified:** omitted or blocked check and the reason.

Do not turn an unrun command into an inferred success.

Completion criterion: all approved targets pass syntax, link, ownership,
contradiction, dirty-tree, and likely-secret checks; every actual command has
evidence; every remaining check is explicitly unverified.
