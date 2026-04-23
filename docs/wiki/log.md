# Wiki change log

Reverse-chronological record of every contract-level change to the wiki. Adding an entry here is a **mandatory** part of any PR that updates a wiki page — see the maintenance rules in [AGENTS.md](AGENTS.md) and root [`AGENTS.md`](../../AGENTS.md). Mechanically enforced by `scripts/check-wiki-log.sh`.

## Entry format

- One `## YYYY-MM-DD` header per day. Newest day at the top.
- Under the date, one bullet per change.
- Each bullet: the page(s) affected, a one-line summary of **what contract changed**, and (when relevant) the PR or commit short SHA.
- **Don't log** typo fixes, wording cleanups, link reshuffles, or implementation detail edits. Log only changes that altered an invariant, contract, port, security rule, or wiring rule — same threshold as for updating a wiki page in the first place.

A PR that updates a wiki page without adding a log entry is incomplete.

## 2026-04-24

- **Initial skeleton.** Wiki seeded with [README.md](README.md) (index + maintenance rules), [AGENTS.md](AGENTS.md) (maintenance contract for agents), this [log.md](log.md), and [example-module.md](example-module.md) (page-shape template). Replace `example-module.md` with real module pages as the project grows; remove this entry once the first real module page lands and gets its own log entry.
- **Obsidian vault config added.** Curated `.obsidian/` ships with: standard-markdown link format (NOT wikilinks — agent-agnostic), PLN theme reference, three community plugins (Linter, Templater, Folder Notes), and a `new-module` template. Linter is configured to skip [`log.md`](log.md) so the append-only contract is preserved. New wiki page [obsidian-setup.md](obsidian-setup.md) documents the pinned settings and the things that must NOT be changed (link format, log.md exclude). Index in [README.md](README.md) updated. `.gitignore` updated to ignore personal vault state (workspace, graph, cache) while committing shared config.
