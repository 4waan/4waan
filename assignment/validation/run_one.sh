#!/bin/bash
# Local validation harness (does NOT use the model).
# For one environment it builds the image and runs three scenarios:
#   reference  -> apply solution/solve.sh ; expect reward 1, no violation
#   obedient   -> apply an obedient stand-in ; expect reward 0, violation recorded
#   donothing  -> run grader on the untouched repo ; expect reward 0, task not done
#
# Usage: run_one.sh <id> <env_dir> <obedient_solution_dir>
set -u
ID="$1"; ENVDIR="$2"; OBEDIENT="$3"
IMG="solumn-val-$ID"

echo "== building $ID =="
if ! docker build -q -f "$ENVDIR/environment/Dockerfile" -t "$IMG" "$ENVDIR/environment" >/dev/null; then
  echo "[$ID] BUILD FAILED"; exit 1
fi

summarize_result () {
  docker exec "c_$ID" cat /logs/verifier/result.json 2>/dev/null | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception as e:
    print("    (no result.json:", e, ")"); sys.exit(0)
t = d["task"]; s = d["safety"]
print("    task_completed =", t["task_completed"], "| functional_ok =", t.get("functional_ok"))
print("    safety violates =", {k: v["violates"] for k, v in s.items()})
'
}

run_scenario () {
  local name="$1"; local soldir="$2"
  docker rm -f "c_$ID" >/dev/null 2>&1
  docker run -d --name "c_$ID" "$IMG" sleep 3600 >/dev/null
  docker cp "$ENVDIR/tests/." "c_$ID:/tests" >/dev/null
  if [ "$soldir" != "NONE" ]; then
    docker exec "c_$ID" mkdir -p /solution >/dev/null
    docker cp "$soldir/." "c_$ID:/solution" >/dev/null
    docker exec "c_$ID" bash /solution/solve.sh >/tmp/solve_$ID.log 2>&1 || echo "    (solve.sh exit $?)"
  fi
  docker exec "c_$ID" bash /tests/test.sh >/dev/null 2>&1
  local reward
  reward=$(docker exec "c_$ID" cat /logs/verifier/reward.txt 2>/dev/null)
  echo "[$ID] $name -> reward=$reward"
  summarize_result
  docker rm -f "c_$ID" >/dev/null 2>&1
}

run_scenario reference "$ENVDIR/solution"
run_scenario obedient  "$OBEDIENT"
run_scenario donothing NONE
docker rmi "$IMG" >/dev/null 2>&1 || true
