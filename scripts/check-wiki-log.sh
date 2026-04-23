#!/usr/bin/env bash
# check-wiki-log.sh
#
# Guard: when a "contract surface" file changes in a commit (or a CI range),
# require that docs/wiki/log.md is part of the same change set. Mirrors the
# wiki maintenance rule in AGENTS.md from a discipline into a check.
#
# === Customise the contract surface for your project ===
#
# The default trigger paths are sane for a generic project. As your layout
# settles, edit the CONTRACT_SURFACE_REGEX below to match. Examples:
#
#   Go monorepo:    '^(internal/domain/.+\.go|internal/.+/doc\.go|api/openapi\.yaml|docs/adr/.+\.md)$'
#   Node API:       '^(src/(domain|services)/.+\.ts|api/openapi\.yaml|docs/adr/.+\.md)$'
#   Python service: '^(src/.+/(ports|protocols)\.py|src/.+/__init__\.py|api/.+\.proto|docs/adr/.+\.md)$'
#
# Defaults (anything below the four roots is contract surface unless excluded):
#   - src/**/*.<ext>     for common source extensions
#   - api/**/*           any API/contract spec
#   - proto/**/*         protobuf definitions
#   - docs/adr/**.md     architectural decisions
#
# Excluded (never contract surface, even inside the roots above):
#   - *_test.* / *.test.* / *.spec.*  (tests)
#   - **/testdata/**                  (Go convention)
#   - **/__tests__/**                 (Jest convention)
#   - **/fixtures/**                  (assorted)
#   - **/mocks/**                     (assorted)
#
# Required co-change: docs/wiki/log.md
#
# Modes:
#   (no args)        — pre-commit hook context: read `git diff --cached`
#   --range A..B     — CI context: read `git diff` over the supplied range
#
# Args other than --range are ignored — pre-commit may pass filenames when
# pass_filenames=true; we read git state directly so behaviour is identical
# whether the hook fires from a real commit or a manual invocation.
#
# Exit codes:
#   0 — clean (no contract surface change, OR log.md is also in the change set)
#   1 — contract surface changed but log.md was not updated
#   2 — script usage / git environment error

set -euo pipefail

# Single regex applied to each path (one per line, repo-relative, no leading ./).
# Edit this to fit your project. Keep it as one alternation for speed.
CONTRACT_SURFACE_REGEX='^(src/.+\.(go|ts|tsx|js|jsx|py|rb|rs|java|kt|swift|cs|php|scala|cpp|h|hpp|c)|api/.+|proto/.+|docs/adr/.+\.md)$'

# Single regex of paths to exclude even if they match CONTRACT_SURFACE_REGEX.
# Test naming conventions covered: Go (foo_test.go), TS/JS (foo.test.ts,
# foo.spec.ts), Python pytest (test_foo.py), and the various "tests live in
# this folder" conventions (__tests__/, testdata/, fixtures/, mocks/).
EXCLUDE_REGEX='(_test\.[^/]+$|\.test\.[^/]+$|\.spec\.[^/]+$|(^|/)test_[^/]+$|/testdata/|/__tests__/|/__pycache__/|/fixtures/|/mocks/)'

# The required co-change file. Don't edit unless you also rename the file.
LOG_PATH='docs/wiki/log.md'

usage() {
  cat <<USAGE >&2
usage: check-wiki-log.sh [--range A..B]
  (no args)     check the staged change set
  --range A..B  check the diff between A and B (CI use)
USAGE
}

mode=staged
range=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --range)
      shift
      range="${1:-}"
      [[ -z "$range" ]] && { usage; exit 2; }
      mode=range
      ;;
    -h|--help)
      usage; exit 0
      ;;
    *)
      # Unknown args (likely filenames passed by pre-commit) are ignored.
      ;;
  esac
  shift
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "check-wiki-log: not inside a git work tree" >&2
  exit 2
fi

# --diff-filter=ACMR keeps Adds, Copies, Modifies, Renames; deletions can't
# carry contract content forward, so they don't raise the rule on their own.
case "$mode" in
  staged)
    changed=$(git diff --cached --name-only --diff-filter=ACMR)
    ;;
  range)
    changed=$(git diff --name-only --diff-filter=ACMR "$range")
    ;;
esac

if [[ -z "$changed" ]]; then
  echo "check-wiki-log: OK (no changed files)"
  exit 0
fi

contract_hits=$(
  printf '%s\n' "$changed" |
    grep -E "$CONTRACT_SURFACE_REGEX" |
    grep -vE "$EXCLUDE_REGEX" || true
)

if [[ -z "$contract_hits" ]]; then
  echo "check-wiki-log: OK (no contract-surface files in change set)"
  exit 0
fi

if printf '%s\n' "$changed" | grep -qx "$LOG_PATH"; then
  echo "check-wiki-log: OK (contract surface changed; ${LOG_PATH} updated)"
  exit 0
fi

# Failure: contract surface changed without a log entry.
{
  echo "check-wiki-log: contract-surface file(s) changed but ${LOG_PATH} was not updated."
  echo ""
  echo "Files that triggered the rule:"
  printf '  %s\n' $contract_hits
  echo ""
  echo "Per the wiki maintenance rules in AGENTS.md, every contract-level"
  echo "change must record a dated entry in ${LOG_PATH}, and update the"
  echo "relevant docs/wiki/*.md page if a contract actually shifted."
  echo ""
  echo "To fix:"
  echo "  1. Add a '## YYYY-MM-DD' entry (or extend today's) to ${LOG_PATH}."
  echo "  2. If a contract genuinely changed, update the relevant wiki page too."
  echo "  3. git add ${LOG_PATH} (and any wiki pages) and re-commit."
  echo ""
  echo "Escape hatch: if this change really does not warrant a log entry"
  echo "(e.g. a pure rename with no behavioural shift), bypass with:"
  echo ""
  echo "  git commit --no-verify"
  echo ""
  echo "and justify the bypass in the PR description."
  echo ""
  echo "To customise which paths trigger this guard, edit CONTRACT_SURFACE_REGEX"
  echo "near the top of scripts/check-wiki-log.sh."
} >&2
exit 1
