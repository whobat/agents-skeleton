#!/usr/bin/env bash
# check-no-secrets_test.sh
#
# Self-test for check-no-secrets.sh. Plants a PEM header in a temp tree and
# asserts the guard fails; removes it and asserts the guard passes; verifies
# allow-listed paths bypass the check.
#
# Exit codes:
#   0 — all cases passed
#   1 — at least one case failed
#   2 — environment/setup error

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${script_dir}/check-no-secrets.sh"

[[ -f "$guard" ]] || { echo "guard not found: $guard" >&2; exit 2; }

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "${tmpdir}/scripts" "${tmpdir}/src" "${tmpdir}/src/testdata"
cp "${guard}" "${tmpdir}/scripts/"
echo "package main" > "${tmpdir}/src/main.go"

failures=0

run_case() {
  local name="$1" expected="$2"
  local actual
  set +e
  ( cd "${tmpdir}" && bash scripts/check-no-secrets.sh ) >/dev/null 2>&1
  actual=$?
  set -e
  if [[ "$actual" -ne "$expected" ]]; then
    printf 'FAIL: %-50s (expected %d, got %d)\n' "$name" "$expected" "$actual" >&2
    failures=$((failures + 1))
  else
    printf 'ok:   %s\n' "$name"
  fi
}

# 1. Clean tree → 0
run_case "clean tree" 0

# 2. Plant a leak in tracked source → 1
echo '-----BEGIN RSA PRIVATE KEY-----' > "${tmpdir}/src/leaked.pem"
run_case "leaked private key in src/" 1
rm "${tmpdir}/src/leaked.pem"

# 3. Same content under testdata/ → 0 (allow-listed)
echo '-----BEGIN RSA PRIVATE KEY-----' > "${tmpdir}/src/testdata/fixture.pem"
run_case "PEM in testdata/ allow-listed" 0
rm "${tmpdir}/src/testdata/fixture.pem"

# 4. Plant in fixtures/ → 0 (allow-listed)
mkdir -p "${tmpdir}/fixtures"
echo '-----BEGIN EC PRIVATE KEY-----' > "${tmpdir}/fixtures/key.pem"
run_case "PEM in fixtures/ allow-listed" 0
rm -rf "${tmpdir}/fixtures"

# 5. OpenSSH private key in src/ → 1
echo '-----BEGIN OPENSSH PRIVATE KEY-----' > "${tmpdir}/src/sshkey"
run_case "OpenSSH private key leak" 1
rm "${tmpdir}/src/sshkey"

echo ""
if [[ "$failures" -gt 0 ]]; then
  echo "check-no-secrets_test: $failures case(s) failed" >&2
  exit 1
fi
echo "check-no-secrets_test: all cases passed"
