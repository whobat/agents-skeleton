# Example module

> **Template page.** Copy this file to a new name (e.g. `domain-orders.md`, `service-billing.md`, `adapter-stripe.md`) and replace the content with the real module's invariants and contracts. Delete this `> Template page` blockquote when you start writing.

## Purpose

One to three sentences. **Why does this module exist?** What does it own that nothing else does? What does it deliberately NOT own (so readers don't accidentally extend it)?

Example: *"`adapter-stripe` is the payment-gateway adapter for the `payments.Gateway` port. It owns RFC-8174-grade idempotency keys, retry classification, and webhook signature verification. It does NOT own ledger reconciliation — that's the `service/ledger` use case."*

## Key types / contracts

A small table of the public surface that callers depend on.

| Type / Function | Purpose | Notes |
|-----------------|---------|-------|
| `Gateway.Charge(ctx, req) → Result` | Settle a single payment | Idempotent on `req.IdempotencyKey`; returns `ErrPermanent` for 4xx, `ErrRetryable` for 5xx + network |
| `Gateway.Refund(ctx, charge_id) → Refund` | Reverse a settled charge | Partial refunds use `Amount`; zero means full refund |
| `WebhookHandler` | HTTP handler for Stripe webhooks | Verifies HMAC signature; rejects events older than 5 minutes |

## Invariants

Numbered list of the hard rules — the things that tests guarantee won't change.

1. **Idempotency keys are required** on every mutating call. Calling `Charge` without one returns `ErrInvalidRequest`. The composition root never auto-generates them.
2. **Errors are classified into two sentinels.** `ErrRetryable` (network, 5xx, rate-limit) and `ErrPermanent` (4xx, decline, fraud). Callers MUST `errors.Is` — string-matching on error messages is forbidden.
3. **Webhook events older than 5 minutes are rejected.** This is replay protection; the timestamp comes from the signature header.
4. **Plaintext card data never enters this package.** Callers pass tokenised payment methods (Stripe `pm_*` IDs); the adapter has no opinion on how the token was obtained.

## Files

Only stable entry points. Don't list every file.

- `gateway.go` — `Gateway` interface implementation
- `webhook.go` — `WebhookHandler`
- `errors.go` — `ErrRetryable`, `ErrPermanent`, classification

## Related

- Domain: [domain-payments.md](.) — defines the `Gateway` port this implements
- Service: [services.md](.) — `billing` orchestrates this adapter
- ADR: [`docs/adr/ADR-007-payment-provider.md`](../adr/) — why Stripe, alternatives considered
