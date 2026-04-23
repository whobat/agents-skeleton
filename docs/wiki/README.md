# Codebase Wiki

This wiki is the entry point for any human or AI agent working on the codebase. Each module gets a page covering its **invariants, contracts, and gotchas** — the things you can't recover from `grep`. Start here before reading source.

The wiki is plain markdown. Any tool that respects the [`AGENTS.md`](https://agents.md) convention reads it (Codex CLI, OpenCode, Aider, Cursor, Claude Code, ...).

## Pages

> Replace this placeholder list as you add real module pages.

- [example-module.md](example-module.md) — page-shape template (delete or rename when you have your first real module)
- [obsidian-setup.md](obsidian-setup.md) — Obsidian vault config: plugins, theme, what to commit, what's pinned and why

## How to maintain this wiki

These pages describe **invariants and contracts**, not implementations. The implementation can change freely without updating the wiki — it's only when the *contract* shifts (a port signature, an invariant, a state machine, a security rule) that a wiki page should change.

**Rules of thumb:**
1. **Don't list filenames** unless they are stable entry points. `grep` is faster than wiki maintenance.
2. **Don't quote function bodies.** They rot. Quote the rule, not the code.
3. **Lead with "why"** — the constraint, the threat model, the RFC. Future readers need this most.
4. **Cross-link freely.** Pages should be 50–200 lines. If a page grows past that, split it.
5. **When you change a port signature or an invariant**, update the wiki page in the same PR.
6. **Every wiki update adds a dated entry to [`log.md`](log.md).** Non-negotiable — see [AGENTS.md](AGENTS.md).

When adding a new module: add a wiki page (~50–200 lines), a one-line entry to this index, and a pointer in the nearest `AGENTS.md`.

## Page shape

Every page should have, in roughly this order:
- **Purpose** — 1–3 sentences. Why does this module exist?
- **Key types / contracts** — small table or list.
- **Invariants** / hard rules (numbered).
- **Files** — short list of stable entry points only (don't list every file).
- **Related** — cross-links to neighbouring pages and ADRs.

Keep it conversational. Lead with the "why".

See [example-module.md](example-module.md) for a worked template.

## Change log

[`log.md`](log.md) — reverse-chronological record of every contract-level wiki change, dated. **Mandatory** part of any wiki-touching PR. Mechanically enforced by `scripts/check-wiki-log.sh`.

## Source of truth pointers

Add the canonical references for this project below as you adopt them:

| What | Where |
|------|-------|
| Product PRD / requirements | _link_ |
| Architectural decisions | [`docs/adr/`](../adr/) |
| API contract | _e.g. `api/openapi.yaml`, `proto/*.proto`, `schema.graphql`_ |
| Database schema | _e.g. `migrations/*.sql`, `prisma/schema.prisma`_ |
| Tooling / CI rules | root [`AGENTS.md`](../../AGENTS.md) |
