# Contributing

This project helps agents change repository instructions safely. Contributions
must keep its core promise: decisions come from repository evidence, and
instruction edits or installations require explicit approval.

For instruction changes, include a red scenario: a realistic prompt that would
cause an unsafe result before the change, such as replacing an existing
`AGENTS.md` after the user says "modernize everything." State the expected
safe behavior and add or update the smallest relevant test or transcript.

Run the full check before submitting a change:

```bash
bash tests/run.sh
```

Do not add consumer-project policy to this repository. It provides the process
for deriving local policy; the consuming repository owns its own instructions,
commands, security rules, and tool choices.
