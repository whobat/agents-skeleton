# ADR-001: Record architectural decisions

- **Status:** Accepted
- **Date:** 2026-04-24
- **Deciders:** project owner

## Context

Architectural decisions accumulate silently as a project grows. By the time someone asks "why did we choose X?" the original context is lost — the trade-off, the alternatives, the constraint that no longer applies. This makes it expensive to revisit decisions and easy to accidentally re-litigate the same ground.

## Decision

We will record architectural decisions as Architecture Decision Records (ADRs) in `docs/adr/`, one file per decision, numbered sequentially.

Each ADR follows the template in [`ADR-template.md`](ADR-template.md): context, decision, alternatives, consequences. Format adapted from [Michael Nygard's original proposal](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).

## Alternatives considered

### Option A: Record decisions in the wiki only
- Pros: One fewer place to look.
- Cons: The wiki captures the *current* contract; it doesn't preserve the *why* behind a contract change. Wiki pages get rewritten; ADRs are append-only history.
- Why not chosen: We need both. The wiki tells you what's true now; the ADR tells you why we got here.

### Option B: Keep decisions in PR descriptions / commit messages
- Pros: Zero extra files.
- Cons: PRs and commits are hard to find six months later. They're per-change, not per-decision — the decision is often spread across multiple PRs.
- Why not chosen: Discoverability matters more than file count.

## Consequences

- **Positive:** New contributors (human or agent) can read `docs/adr/` start-to-finish and understand the project's evolution. Revisiting a decision starts from "here's why we chose this, here's what we considered" rather than guesswork.
- **Negative:** Adding an ADR is a small bit of friction on every architectural decision. The trade-off is worth it; if it isn't, the decision probably wasn't architectural.
- **Neutral:** ADRs are immutable once accepted. Superseding decisions are recorded as new ADRs that mark the old one's status as `Superseded by ADR-XXX`.

## Notes

- ADRs are referenced from the wiki (e.g. a `domain-payments.md` page may link to `ADR-007-payment-provider.md`).
- The `check-wiki-log` guard treats `docs/adr/**` as contract surface — adding or modifying an ADR requires a `docs/wiki/log.md` entry. This keeps decision history and wiki state in sync.
- Numbering is strict sequential. Renaming an existing ADR breaks history; create a new one instead.
