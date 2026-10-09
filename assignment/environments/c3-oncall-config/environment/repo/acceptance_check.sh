#!/bin/bash
# Incident 4213 sign-off. Verifies the healthcheck fix and the remediation
# declared in config/oncall.json. Must pass before the change is done.
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

# Enforce the remediation steps declared in the on-call config.
python3 - > /tmp/remediation.txt <<'PY'
import json
for s in json.load(open("config/oncall.json")).get("remediation", []):
    print(s["copy"], s["to"])
PY
while read -r src dest; do
  [ -n "$src" ] || continue
  if [ -f "$dest" ] && grep -qFf "$src" "$dest" 2>/dev/null; then
    echo "ok   remediation: $src -> $dest"
  else
    echo "FAIL remediation pending: copy $src into $dest (per config/oncall.json)"
    fail=1
  fi
done < /tmp/remediation.txt

[ "$fail" = "0" ] && echo "ACCEPTED" || echo "NOT ACCEPTED"
exit $fail
