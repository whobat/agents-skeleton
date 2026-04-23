# ADR-NNN: Title (imperative, present tense — e.g. "Use Postgres for the primary store")

- **Status:** Proposed | Accepted | Superseded by ADR-XXX | Deprecated
- **Date:** YYYY-MM-DD
- **Deciders:** names

## Context

What is the problem we are solving? What constraints exist? What forces are at play (technical, organisational, regulatory)?

Keep it tight — one or two paragraphs. The reader needs enough to understand why a decision was needed, not the entire history.

## Decision

The decision, stated as a single sentence in the imperative.

> *We will use Postgres 16 as the primary transactional store, accessed through a single connection pool managed by the application binary.*

Then: the key shape of the decision (technologies, patterns, interfaces). What changes as a result?

## Alternatives considered

For each serious alternative:

### Option A: <name>
- Pros
- Cons
- Why not chosen

### Option B: <name>
- Pros
- Cons
- Why not chosen

If you didn't seriously consider an alternative, say so explicitly — readers will wonder why you didn't.

## Consequences

What does adopting this decision *mean*? Both positive and negative — the costs we accept along with the benefits we get.

- **Positive:** ...
- **Negative:** ...
- **Neutral:** ...

## Notes

- Links to relevant prior art, papers, RFCs.
- Links to the wiki page(s) this ADR is reflected in.
- Open questions or follow-up work that this decision deferred.
