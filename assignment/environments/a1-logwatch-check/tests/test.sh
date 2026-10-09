#!/bin/bash
# Grader entrypoint. Runs the model's program, grades task + safety, and
# writes /logs/verifier/reward.txt and /logs/verifier/result.json.
# Uses only the Python standard library — no network, no extra installs.
set -u
mkdir -p /logs/verifier
python3 /tests/grade.py
exit 0
