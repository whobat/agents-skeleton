#!/usr/bin/env bash
# check-no-secrets.sh
#
# Guard: fail if any private-key PEM block has leaked into the tracked source
# tree. Runs as a lightweight grep step — no language toolchain required, so
# it sits ahead of any heavy build.
#
# Forbidden PEM headers (case-sensitive, since real PEM is upper-case):
#
#   -----BEGIN RSA PRIVATE KEY-----
#   -----BEGIN EC PRIVATE KEY-----
#   -----BEGIN PRIVATE KEY-----
#   -----BEGIN OPENSSH PRIVATE KEY-----
#
# Allow-listed paths (exempt from the check):
#   - anything under a testdata/  directory (Go convention for fixtures)
#   - anything under a fixtures/  directory (web e2e test PEMs live here)
#   - anything under a __tests__/ directory (Jest convention)
#   - this script and its self-test (reference the headers as string data)
#
# Exit codes:
#   0 — clean
#   1 — leak detected (grep output echoed to stderr with file:line)
#   2 — script usage / environment error

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
cd "${repo_root}"

# Single alternation pattern. grep -E treats these as regex, but the only
# metacharacter in the PEM headers is '-', which is literal.
pattern='-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'

set +e
raw_hits="$(
  grep -rEn \
    --binary-files=without-match \
    --exclude-dir='.git' \
    --exclude-dir='node_modules' \
    --exclude-dir='vendor' \
    --exclude-dir='testdata' \
    --exclude-dir='fixtures' \
    --exclude-dir='__tests__' \
    --exclude='check-no-secrets.sh' \
    --exclude='check-no-secrets_test.sh' \
    -- "${pattern}" .
)"
rc=$?
set -e

# grep exit codes: 0 = matches, 1 = no matches, >=2 = error.
if [[ "${rc}" -ge 2 ]]; then
  echo "check-no-secrets: grep failed (rc=${rc})" >&2
  exit 2
fi

if [[ "${rc}" -eq 1 ]]; then
  echo "check-no-secrets: OK (no private-key PEM leaks)"
  exit 0
fi

echo "check-no-secrets: forbidden PEM header(s) found:" >&2
printf '%s\n' "${raw_hits}" >&2
echo "" >&2
echo "If the match is a legitimate fixture, move it under a testdata/," >&2
echo "fixtures/, or __tests__/ directory." >&2
exit 1
