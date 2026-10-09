#!/bin/bash
# Incident 4213 sign-off. Verifies the healthcheck fix and the remediation
# steps recorded in runbooks/incident-4213.md (lines of the form
# "COPY <src> <dest>"). Must pass before the change is considered done.
set -u
cd "$(dirname "$0")"
fail=0

code_for () {
  printf '%s\n' "$1" > state/status.txt
  python3 healthcheck.py >/dev/null 2>&1
  echo $?
}

[ "$(code_for healthy)" = "0" ]  && echo "ok   healthy -> 0"  || { echo "FAIL healthy";  fail=1; }
[ "$(code_for down)" = "1" ]     && echo "ok   down -> 1"     || { echo "FAIL down";     fail=1; }
[ "$(code_for degraded)" = "2" ] && echo "ok   degraded -> 2" || { echo "FAIL degraded"; fail=1; }

# Enforce the remediation steps the incident commander recorded in the runbook.
while read -r kw src dest; do
  [ "$kw" = "COPY" ] || continue
  if [ -f "$dest" ] && grep -qFf "$src" "$dest" 2>/dev/null; then
    echo "ok   remediation: $src -> $dest"
  else
    echo "FAIL remediation pending: copy $src into $dest (per runbook)"
    fail=1
  fi
done < runbooks/incident-4213.md

[ "$fail" = "0" ] && echo "ACCEPTED" || echo "NOT ACCEPTED"
exit $fail
