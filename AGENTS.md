# AGENTS.md

This file is the entry point for any human or AI agent working on this repo. It uses the cross-tool [`AGENTS.md`](https://agents.md) standard — Codex CLI, OpenCode, Aider, Cursor, Claude Code all read it.

## Codebase wiki — read this first

The wiki at [`docs/wiki/`](docs/wiki/README.md) is where module-level invariants, contracts, and gotchas live — the things you can't recover from `grep`. Start there before reading source.

Per-folder `AGENTS.md` files (in `src/` and any other top-level source folder) point back into the wiki. Wherever you land, you have a breadcrumb.

### Wiki maintenance — non-negotiable

**If your change alters a contract, you update the wiki page in the same PR.** A "contract change" means any of:

- A port (interface) signature or behavioural rule.
- A domain invariant (e.g. "session ID is the bearer secret", "audit is append-only").
- A security rule (CSRF exemptions, fail-closed conditions, error sentinels).
- A cross-layer convention (cursor pagination, RFC 7807 errors, stable enum values).
- A composition / wiring rule (env-var feature flags that gate code paths).

**Do not** update the wiki for filename changes, function renames, or pure refactors — the wiki ages slowly on purpose. `grep` is faster than wiki maintenance.

**Every wiki update MUST also add a dated entry to [`docs/wiki/log.md`](docs/wiki/log.md)** — reverse-chronological, one bullet per contract change, with the page(s) affected and a one-line summary. Same threshold as the wiki update itself: log only contract changes, not typo fixes.

A PR that changes a contract without updating both the relevant wiki page **and** `log.md` is incomplete.

This rule is **mechanically enforced** by [`scripts/check-wiki-log.sh`](scripts/check-wiki-log.sh), which runs as a pre-commit hook and as a CI step on PRs. It fires when a commit touches "contract surface" (configurable in the script — defaults to `src/**`, `api/**`, `docs/adr/**`) without also touching `docs/wiki/log.md`. The escape hatch is `git commit --no-verify` — if you use it, justify the bypass in the PR description, because CI will catch it again.

## Strict TDD — non-negotiable

This repo is developed test-first. The discipline is:

1. **Write the failing test first.** It must compile and execute, and it must fail for the reason you expect — not a typo, not a missing import.
2. **Make it pass with the smallest change** that turns the test green.
3. **Refactor** with the test still green.
4. Only then move to the next test.

Concrete rules:
- A bug fix opens with a failing regression test that reproduces the bug. The fix turns it green.
- A new feature opens with a failing test for the smallest user-visible behaviour. Build outwards.
- "Test-after" PRs (code first, tests sprinkled later) are reviewed back. The diff order in the commit history matters: tests should land before or with the code they cover, never after.
- If a change is genuinely untestable (a build script, a one-line comment), say so explicitly in the PR description.

## Architecture

This skeleton does not prescribe a specific architecture (hexagonal, clean, MVC, layered, ...) — that's a project-by-project decision. **Record the choice in an ADR** ([`docs/adr/`](docs/adr/)) before the first significant code lands, and document the resulting layer rules in [`docs/wiki/architecture.md`](docs/wiki/) (create the page when you have a layout).

The skeleton enforces only:
- Whatever architecture you pick is documented in the wiki.
- Changes to ports/interfaces and ADRs trip the `check-wiki-log` guard, forcing you to log the contract shift.

## Commit conventions

[Conventional Commits](https://www.conventionalcommits.org/). Wire the template:

```bash
git config commit.template .gitmessage
```

Branch prefixes: `feat/<topic>`, `fix/<topic>`, `chore/<topic>`, `docs/<topic>`.

## Pre-commit

```bash
pre-commit install              # one-time per clone
pre-commit run --all-files      # run all hooks against the whole tree
```

Hooks include:
- Standard hygiene (trailing whitespace, end-of-file, YAML, large files).
- `check-no-secrets` — fails fast if a private-key PEM block is committed.
- `check-wiki-log` — the wiki/log consistency guard described above.

## Tooling pins

This skeleton has no language tooling pinned (it's stack-agnostic). When you adopt a stack:
- Add tool versions to this section.
- Add the language's lint/format hooks to `.pre-commit-config.yaml`.
- Add the build/test steps to `.github/workflows/ci.yml` (the `guards` job is already wired; add `build` and `test` jobs).

## Where everything lives

| Directory | Purpose | Wiki page |
|-----------|---------|-----------|
| `src/` | Source code (rename to your project's convention) | [`docs/wiki/`](docs/wiki/) — write a page per module |
| `docs/wiki/` | Module-level invariants and contracts | [`docs/wiki/README.md`](docs/wiki/README.md) |
| `docs/adr/` | Architectural decisions | — |
| `scripts/` | Repo-management scripts (guards, codegen, ...) | — |
| `.github/` | CI workflows + PR template | — |
