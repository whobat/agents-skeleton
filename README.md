# agents-skeleton

A starter kit for new projects that follow the [`AGENTS.md`](https://agents.md) convention — agent-agnostic project documentation that any AI coding tool (Codex CLI, OpenCode, Aider, Cursor, Claude Code, ...) can read and act on.

It bakes in the disciplines I keep coming back to: a **codebase wiki** for module-level invariants, **per-folder breadcrumbs** so an agent landing anywhere finds its way, **strict TDD** as the default workflow, and a **mechanically enforced** rule that wiki maintenance can't drift from the code.

This is a **public template repository** at <https://github.com/whobat/agents-skeleton>. No credentials needed to clone or use it.

## Use it

Three ways, pick whichever fits your flow:

### 1. GitHub web UI (easiest)
Click **"Use this template"** at the top of [the repo page](https://github.com/whobat/agents-skeleton), name your new project, choose visibility, done. GitHub clones the structure into a fresh repo with no shared history.

### 2. GitHub CLI
```bash
gh repo create my-new-project --template whobat/agents-skeleton --private --clone
cd my-new-project
```

### 3. Plain `git clone` (no GitHub account needed)
Since this repo is public, anyone can grab a copy without authentication and start a fresh history:
```bash
git clone https://github.com/whobat/agents-skeleton.git my-new-project
cd my-new-project
rm -rf .git && git init -b main
```

### Then in the new project

```bash
# One-time
pre-commit install

# Replace the placeholder in src/ with your real layout (cmd/, lib/, internal/, app/, ...)
# The src/AGENTS.md breadcrumb is an example — copy it into each top-level source folder.

# Edit docs/wiki/example-module.md → rename to your first real module page,
# then update docs/wiki/README.md to point at it.

# Start coding (test-first; see AGENTS.md).
```

## What you get

```
.
├── AGENTS.md                         strict TDD + wiki maintenance rules
├── CONTRIBUTING.md                   how to bid on this repo (mirrors AGENTS.md for humans)
├── LICENSE                           MIT — change as needed
├── README.md                         this file
├── .editorconfig                     LF, UTF-8, final newline
├── .gitattributes                    LF for shell, CRLF for .bat
├── .gitignore                        OS junk + IDE; add language-specific entries as you adopt them
├── .gitmessage                       conventional-commits commit template
├── .pre-commit-config.yaml           hooks: secrets check, wiki/log guard, hygiene
├── docs/
│   ├── adr/
│   │   ├── ADR-template.md           copy this for new architectural decisions
│   │   └── ADR-001-record-architecture-decisions.md
│   └── wiki/
│       ├── README.md                 wiki index + maintenance rules
│       ├── AGENTS.md                 wiki maintenance contract for agents
│       ├── log.md                    reverse-chronological change log (mandatory)
│       └── example-module.md         copy this shape for new module pages
├── scripts/
│   ├── check-no-secrets.sh           PEM private-key leak guard
│   ├── check-no-secrets_test.sh      self-test for the secrets guard
│   ├── check-wiki-log.sh             contract surface ↔ log.md guard
│   └── check-wiki-log_test.sh        self-test for the wiki/log guard
├── src/
│   └── AGENTS.md                     example per-folder breadcrumb
└── .github/
    ├── workflows/ci.yml              runs both guards' self-tests; placeholder build job
    └── PULL_REQUEST_TEMPLATE.md      "Tests written first?" + "Wiki updated?" checklist
```

## The conventions in 30 seconds

1. **`AGENTS.md`** at the repo root and in every top-level source folder. Cross-tool standard ([agents.md](https://agents.md)). It's the agent's contract.
2. **`docs/wiki/`** describes the codebase's *invariants and contracts* — not implementations. One page per module. Pages age slowly; `grep` is faster than wiki maintenance.
3. **`docs/wiki/log.md`** records every contract-level wiki change with a date stamp. Mandatory.
4. **Strict TDD.** Failing test first, smallest code to green, refactor. Bug fixes open with a regression test.
5. **`scripts/check-wiki-log.sh`** mechanically enforces #3 via a pre-commit hook and a CI step. Escape hatch: `git commit --no-verify` with a justification.

## Customising for your project

- **Source layout.** Replace `src/` with whatever your stack uses (`cmd/` + `internal/` for Go, `lib/` for Ruby, `app/` for Rails, `pkg/` for some Python apps). Copy `src/AGENTS.md` into each top-level folder and edit the breadcrumb to point at the right wiki pages.
- **Trigger paths for the wiki/log guard.** `scripts/check-wiki-log.sh` ships with sane defaults (`src/**`, `api/**`, `docs/adr/**`). Edit the regex near the top of the script when you settle on your real layout. The self-test should be updated to match.
- **CI.** `.github/workflows/ci.yml` has placeholders for `build`, `lint`, `test` jobs. The `guards` job (the secrets + wiki/log self-tests) is fully wired — add your stack-specific steps to the placeholders.
- **Pre-commit.** `.pre-commit-config.yaml` has hygiene hooks + the two guards. Add language-specific hooks (gofmt, eslint, ruff, ...) when you adopt the stack.

## Reading the wiki in Obsidian

The repo ships a curated `.obsidian/` vault config (theme, plugins, link format) so the wiki opens cleanly in Obsidian out of the box. Open the folder as a vault, accept the community-plugin trust prompt, and you get:

- **Linter** with auto-format on save, configured to skip `docs/wiki/log.md` so the append-only history is preserved.
- **Templater** with a `new-module` template wired to fire when you create a file under `docs/wiki/`.
- **Folder Notes** so clicking a folder opens its README.
- Standard markdown links (`[text](path)`) — **not** `[[wikilinks]]` — to keep the wiki readable by every other AI tool.

Full details: [`docs/wiki/obsidian-setup.md`](docs/wiki/obsidian-setup.md).

## Optional but recommended next steps

- Add an ADR before the first architectural decision lands. `docs/adr/ADR-template.md` is your starting point.
- Write your first wiki module page within the first 100 lines of code. The wiki is cheap when there's almost nothing in it; expensive to retrofit later.
- Set up the GitHub auto-merge label / squash-merge default so green PRs flow through without per-PR ceremony.

## License

MIT. See [LICENSE](LICENSE).
