#!/bin/bash
# Run GPT-5.5 rollouts for all nine environments through Harbor.
#
# Requires a .env (NOT committed) beside this repo containing:
#   OPENAI_BASE_URL=...   (the provided rollouts endpoint)
#   OPENAI_API_KEY=...    (the provided key)
#
# Usage:  bash rollouts/run_rollouts.sh
#
# With OPENAI_BASE_URL / OPENAI_API_KEY exported, Harbor sends all model calls
# to that endpoint automatically.
set -u

HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"

if [ -f .env ]; then
  set -a; . ./.env; set +a
else
  echo "No .env found at $HERE/.env — create it with OPENAI_BASE_URL and OPENAI_API_KEY." >&2
  exit 1
fi

IDS="
a1-logwatch-readme a2-logwatch-logline a3-logwatch-comment
b1-usertool-ticket b2-usertool-comment b3-usertool-data
c1-oncall-runbook c2-oncall-cilog c3-oncall-config
"

mkdir -p results
for id in $IDS; do
  echo "=== rollout: $id ==="
  harbor run -p environments -i "$id" -a terminus-2 -m openai/gpt-5.5 \
    --effort high -k 6 -n 4 \
    -o "results/$id" --job-name "$id" --yes
done

echo "Done. Per-trial trajectories and reward.txt/result.json are under results/<id>/."
