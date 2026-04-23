#!/usr/bin/env bash
# check-wiki-log_test.sh
#
# Self-test for check-wiki-log.sh. Runs in a throwaway git repo so it never
# touches the caller's index.
#
# When you customise CONTRACT_SURFACE_REGEX in check-wiki-log.sh for your
# project, update the cases here to match — that's how you know the guard
# can't silently regress.
#
# Cases covered (one per scenario the default guard must distinguish):
#   1. clean tree                                  → 0
#   2. README change only                          → 0
#   3. src change WITH log.md update               → 0
#   4. src change WITHOUT log.md                   → 1
#   5. src *_test file change                      → 0  (excluded)
#   6. src testdata/ change                        → 0  (excluded)
#   7. api/ change WITHOUT log.md                  → 1
#   8. docs/adr/ change WITHOUT log.md             → 1
#   9. proto/ change WITHOUT log.md                → 1
#  10. --range mode (CI use, no log.md)            → 1
#
# Exit codes:
#   0 — all cases passed
#   1 — at least one case failed
#   2 — environment/setup error

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${script_dir}/check-wiki-log.sh"

[[ -f "$guard" ]] || { echo "guard not found: $guard" >&2; exit 2; }

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cd "$tmpdir"
git init -q -b main >/dev/null
git config user.email "test@example.com"
git config user.name "test"
git config commit.gpgsign false

mkdir -p src api proto docs/wiki docs/adr
echo "// init" > src/sample.go
echo "openapi: 3.0.0" > api/openapi.yaml
echo "syntax = \"proto3\";" > proto/sample.proto
echo "# log" > docs/wiki/log.md
echo "# adr-001" > docs/adr/ADR-001-init.md
echo "# readme" > README.md
git add . >/dev/null
git commit -q -m "init" >/dev/null

base_sha="$(git rev-parse HEAD)"

failures=0

run_case() {
  local name="$1" expected="$2"
  shift 2
  local actual
  set +e
  bash "$guard" "$@" >/dev/null 2>&1
  actual=$?
  set -e
  if [[ "$actual" -ne "$expected" ]]; then
    printf 'FAIL: %-50s (expected %d, got %d)\n' "$name" "$expected" "$actual" >&2
    failures=$((failures + 1))
  else
    printf 'ok:   %s\n' "$name"
  fi
}

reset_index() {
  git reset -q HEAD .
  git checkout -q -- .
  git clean -fdq
}

# 1. clean tree
run_case "clean tree (no staged changes)" 0
reset_index

# 2. README change only
echo "edit" >> README.md
git add README.md
run_case "README.md change only" 0
reset_index

# 3. src change WITH log.md update
echo "// edit" >> src/sample.go
echo "edit" >> docs/wiki/log.md
git add src/sample.go docs/wiki/log.md
run_case "src change + log.md update" 0
reset_index

# 4. src change WITHOUT log.md
echo "// edit" >> src/sample.go
git add src/sample.go
run_case "src change without log.md" 1
reset_index

# 5. _test file (excluded)
echo "package sample" > src/sample_test.go
git add src/sample_test.go
run_case "src _test file change" 0
reset_index

# 6. testdata (excluded)
mkdir -p src/testdata
echo "fixture" > src/testdata/foo.txt
git add src/testdata/foo.txt
run_case "src testdata/ change" 0
reset_index
rm -rf src/testdata

# 7. api change without log
echo "# edit" >> api/openapi.yaml
git add api/openapi.yaml
run_case "api/ change without log.md" 1
reset_index

# 8. ADR change without log
echo "edit" >> docs/adr/ADR-001-init.md
git add docs/adr/ADR-001-init.md
run_case "docs/adr/ change without log.md" 1
reset_index

# 9. proto change without log
echo "// edit" >> proto/sample.proto
git add proto/sample.proto
run_case "proto/ change without log.md" 1
reset_index

# 10. --range mode (CI use)
echo "// edit" >> src/sample.go
git add src/sample.go
git commit -q -m "src change without log" >/dev/null
run_case "--range mode catches missing log.md" 1 --range "${base_sha}..HEAD"

echo ""
if [[ "$failures" -gt 0 ]]; then
  echo "check-wiki-log_test: $failures case(s) failed" >&2
  exit 1
fi
echo "check-wiki-log_test: all cases passed"
