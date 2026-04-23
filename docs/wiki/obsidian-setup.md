# Obsidian setup for this wiki

This codebase ships an `.obsidian/` configuration so the wiki opens cleanly in Obsidian out of the box. The config is committed; personal state (window layout, graph view position) is gitignored.

## First-time open

1. **File → Open vault → this folder.**
2. Obsidian detects community plugins it doesn't trust yet — click **"Trust author and enable plugins"**.
3. Three plugins auto-install: **Linter**, **Templater**, **Folder Notes**.
4. **PLN theme**: if you have it on this machine, Obsidian uses it. If not, copy your existing `<vault>/.obsidian/themes/PLN/` into this repo's `.obsidian/themes/`, OR install via Settings → Appearance → Manage → Browse. Without PLN, Obsidian falls back to default — nothing breaks.

## What's pinned and why

| Setting | Value | Why |
|---------|-------|-----|
| `useMarkdownLinks` | `true` | Standard `[text](path)` links — keeps the wiki readable by Codex, OpenCode, Aider, Cursor, Claude Code. **Do not switch to `[[wikilinks]]`.** |
| `newLinkFormat` | `relative` | File moves don't rot links to other wiki pages |
| `attachmentFolderPath` | `docs/wiki/assets` | Images and binaries stay scoped to the wiki |
| `alwaysUpdateLinks` | `true` | Renaming a file auto-fixes inbound links |
| `cssTheme` | `PLN` | Visual; agent-irrelevant; falls back to default if missing |

## Plugins

### Core (no install needed)
**Outline**, **Backlinks**, **Bookmarks**, **Page Preview**, **Templates**, **Graph view**, **Tags pane**, **Quick switcher**, **Command palette**, **Note composer**.

### Community
| Plugin | Purpose |
|--------|---------|
| **Linter** | Auto-format on save (trailing whitespace, blank-line collapse, headings). **Configured to skip `docs/wiki/log.md`** so the append-only history never gets reorganised |
| **Templater** | `Cmd/Ctrl-P → "Templater: Insert template" → new-module` to start a wiki page with the right shape pre-filled. Also fires automatically when you create a file directly under `docs/wiki/` |
| **Folder Notes** | Click `docs/wiki/` in the file tree → opens README.md |

## Useful shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl-O` | Quick switcher — jump to any wiki page by name |
| `Cmd/Ctrl-P` | Command palette |
| `Cmd/Ctrl-G` | Graph view — visualise wiki structure and orphan pages |
| `Cmd/Ctrl-Shift-F` | Global search |
| Hover on link | Page preview without leaving the current page |
| `Cmd/Ctrl-click` on link | Open in new pane |

## Things you must NOT change

- **Standard markdown links.** Switching `useMarkdownLinks` to `false` (= `[[wikilinks]]`) breaks AI tool compatibility.
- **The Linter exclude for `log.md`.** The append-only contract beats auto-format ergonomics. If the linter rewrites the log, the change-history reading order is destroyed.

## What's gitignored

Personal state, never committed:
```
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/graph.json
.obsidian/cache
.obsidian/themes/PLN/                  # if locally present, kept private
```

Everything else under `.obsidian/` is curated config and committed — share-and-share-alike.

## Adding more plugins later

1. Install in Obsidian as normal.
2. Decide if the plugin's config is shared (commit `.obsidian/plugins/<plugin-id>/data.json`) or personal (gitignore it).
3. Add the plugin ID to `.obsidian/community-plugins.json` so other vault openers auto-install it.

## Related

- [README.md](README.md) — wiki index
- [AGENTS.md](AGENTS.md) — wiki maintenance contract (the rules the Linter must not break)
- Root [`AGENTS.md`](../../AGENTS.md) — TDD + wiki maintenance rules
