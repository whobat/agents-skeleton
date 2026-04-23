# Contributing

This file is for humans. The same disciplines apply to AI agents — see [`AGENTS.md`](AGENTS.md).

## Setup

```bash
pre-commit install
git config commit.template .gitmessage
```

## Workflow

1. **Branch** — `feat/<topic>`, `fix/<topic>`, `chore/<topic>`, or `docs/<topic>`.
2. **Test first** — write the failing test before any production code. See `AGENTS.md` "Strict TDD".
3. **Smallest change to green** — then refactor with the test still passing.
4. **If you change a contract**, update the wiki page in `docs/wiki/` AND add an entry to `docs/wiki/log.md`. The pre-commit hook will block your commit if you forget.
5. **Conventional Commits** for the message: `feat(scope): summary`, `fix(scope): summary`, etc.
6. **PR** — fill in the template (it asks the two questions that matter: tests-first? wiki updated?).

## Reviewing

- The PR template's checklist is the minimum bar.
- "Test-after" PRs (production code first, tests sprinkled later) are reviewed back. Commit history matters.
- A contract change without a wiki + log update is incomplete, even if CI is green by accident.

## Getting unstuck

- Wiki page out of date? Update it in this PR.
- Wiki page missing for the module you're touching? Create it (use `docs/wiki/example-module.md` as a template) and link from `docs/wiki/README.md`.
- Need an architectural decision logged? Copy `docs/adr/ADR-template.md` to a new file and write it up.

## Bypass

The `check-wiki-log` pre-commit hook can be bypassed with `git commit --no-verify`. CI will catch the same case on the PR. **If you bypass, justify it in the PR description** — typically because the change is a pure rename or comment-only edit that does not actually shift a contract.
