# AGENTS.md — `src/`

> **Template breadcrumb.** Rename this directory to whatever your project uses (`cmd/`, `internal/`, `lib/`, `app/`, `pkg/`, ...). Copy this `AGENTS.md` into each top-level source folder and edit it to point at the wiki page(s) for that folder's contents.

You are in source code. Before touching a module, read its wiki page in [`docs/wiki/`](../docs/wiki/) — it documents the invariants and contracts that aren't visible from a file.

## Quick orientation

```
src/
  <module-1>/    → docs/wiki/<module-1>.md
  <module-2>/    → docs/wiki/<module-2>.md
  ...
```

Replace this with the real layout once it stabilises.

## Rules from root `AGENTS.md` that apply here

- **Strict TDD.** Write the failing test first; smallest change to green; refactor.
- **Wiki + log.** If you change a contract (port signature, invariant, security rule), update the relevant `docs/wiki/*.md` page AND `docs/wiki/log.md` in the same PR. The pre-commit hook enforces it.
- **Conventional Commits.** `feat(scope): ...`, `fix(scope): ...`, etc.

## Common tasks

- **Add a new module:** create the source folder + a wiki page (use `docs/wiki/example-module.md` as a template) + a one-line link in `docs/wiki/README.md` + a `docs/wiki/log.md` entry.
- **Change a port/interface signature:** update the wiki page that documents the contract + log entry.
- **Add an architectural decision:** copy `docs/adr/ADR-template.md` to `docs/adr/ADR-NNN-<slug>.md`, then update the relevant wiki page to reflect the new decision.

## Related

- Root [`AGENTS.md`](../AGENTS.md) — TDD discipline + wiki maintenance rules
- [`docs/wiki/`](../docs/wiki/) — module-level invariants and contracts
