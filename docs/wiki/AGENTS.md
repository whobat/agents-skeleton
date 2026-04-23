# AGENTS.md — `docs/wiki/`

This directory **is** the codebase wiki. Start at [README.md](README.md).

## Maintenance contract

The wiki describes **invariants and contracts**, not implementations. Update a page only when one of these changes:

- A port (interface) signature or behaviour rule.
- A domain invariant (e.g. "session ID is the bearer secret", "audit is append-only").
- A security rule (CSRF exemptions, fail-closed conditions, error-classification sentinels).
- A cross-layer convention (cursor pagination, RFC 7807 errors, stable enum values).
- A composition / wiring rule (env-var feature flags that gate code paths).

Do **not** update a wiki page just because a function was renamed, a file moved, or an implementation detail changed. The wiki should age slowly. `grep` is faster than wiki maintenance.

## Change log — non-negotiable

**Every PR that updates a wiki page MUST also add a dated entry to [`log.md`](log.md).** No exceptions. The entry records:

- One `## YYYY-MM-DD` header per day (newest at top — reverse chronological).
- One bullet per change: the page(s) affected + a one-line summary of what contract changed + (optional) PR or short SHA.
- Same threshold as the wiki update itself — log only contract-level changes, not typo fixes or rewording.

A PR that updates a wiki page without a corresponding `log.md` entry is incomplete and will be reviewed back. The full format is documented at the top of `log.md`.

This rule is mechanically enforced by `scripts/check-wiki-log.sh` — pre-commit hook + CI step. The escape hatch is `git commit --no-verify` with a justification in the PR description.

## When adding a new module

1. Copy [`example-module.md`](example-module.md) to a new file named after the module.
2. Write the page (~50–200 lines) following the shape in [README.md](README.md).
3. Add a one-line entry to [README.md](README.md) under the right section.
4. Add or update the nearest `AGENTS.md` (e.g. `src/AGENTS.md`) to link the new page.
5. Add a `log.md` entry.

## Page shape

Every page should have, in roughly this order:
- **Purpose** — 1–3 sentences. Why does this module exist?
- **Key types / contracts** — small table or list.
- **Invariants** / hard rules (numbered).
- **Files** — short list of stable entry points only.
- **Related** — cross-links.

Keep it conversational. Lead with the "why".

## Agent-agnostic by design

These docs are pure markdown with no editor-specific frontmatter. They are read by Codex CLI, OpenCode, Aider, Cursor, Claude Code, and any other tool that respects the `AGENTS.md` convention. Don't add tool-specific syntax.
