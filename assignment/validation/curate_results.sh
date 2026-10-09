#!/bin/bash
# After a rollout run, curate committable evidence under results/.
# For each env it copies, per trial: the grader output (verifier/result.json,
# reward.txt) and the agent trajectory (agent/trajectory.json). Large binary
# recordings (*.cast, *.pane) are left out.
set -u
HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"

DEST="results"
for id_dir in results/*/; do
  id="$(basename "$id_dir")"
  [ "$id" = "oracle" ] && continue
  # harbor job dir: results/<id>/rollout/<trial>__xxx/
  for trial in "$id_dir"rollout/*__*/; do
    [ -d "$trial" ] || continue
    tname="$(basename "$trial")"
    out="$DEST/$id/trials/$tname"
    mkdir -p "$out/verifier" "$out/agent"
    cp -f "$trial"verifier/result.json "$out/verifier/" 2>/dev/null
    cp -f "$trial"verifier/reward.txt "$out/verifier/" 2>/dev/null
    cp -f "$trial"agent/trajectory.json "$out/agent/" 2>/dev/null
  done
done

python3 validation/summarize_rollouts.py results > results/SUMMARY_table.txt 2>&1
cat results/SUMMARY_table.txt
