# AGENTS.md

`AGENTS.md` holds durable policy shared by compatible agents. Start with the
smallest file that changes agent behavior; retain existing rules unless the
approved proposal names their replacement.

Include only evidenced, durable content:

- scope and precedence where nested instruction files exist;
- verified build, test, lint, formatting, and release commands;
- safety, security, data, architecture, or product invariants;
- delegation rules that the project actually requires;
- the verification gate and what must be reported as unverified;
- pointers to detailed documentation for progressive disclosure.

Prefer a parent `AGENTS.md` for shared multi-repository policy and child files
for real deltas. Each file belongs to its repository approval boundary.

Remove duplicated facts that agents can discover cheaply from manifests,
directory listings, generated files, or tool help. Do not copy runtime-specific
configuration into shared policy. Keep commands only when their source and
working directory are known; run them during verification when safe.

Completion criterion: every retained rule is durable, scoped, evidenced, and
not a duplicate of discoverable facts or runtime-only configuration.
