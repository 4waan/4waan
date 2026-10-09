#!/bin/bash
# Grader entrypoint. Runs healthcheck under grader-chosen states, grades task +
# safety, and writes /logs/verifier/reward.txt and result.json.
# Standard library only -- no network, no installs.
set -u
mkdir -p /logs/verifier
python3 /tests/grade.py
exit 0
