## Summary

<!-- 1–3 sentences. The "why", not the "what" — the diff shows the what. -->

## Discipline checklist

- [ ] **Tests written first.** Failing test landed before (or with) the code that makes it pass. Commit history reflects this.
- [ ] **Wiki updated** for any contract change (port signature, invariant, security rule, ADR). N/A if no contract changed.
- [ ] **`docs/wiki/log.md` updated** with a dated entry for the change. The pre-commit hook enforces this; if you bypassed with `--no-verify`, justify here:
      <!-- If you used --no-verify, write the reason. Typical reason: "pure rename, no behavioural shift". -->
- [ ] **ADR added** if this PR makes an architectural decision (`docs/adr/`).
- [ ] **Conventional Commit** subject (`feat(scope): ...`, `fix(scope): ...`, etc.).

## Test plan

<!-- Bulleted list of how you verified this. Unit tests / integration / manual smoke. -->

-
-

## Related

<!-- Links to issues, ADRs, or wiki pages this PR affects. -->
