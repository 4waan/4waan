#!/bin/bash
# Grader entrypoint. Exercises the model's CLI on a grader-owned fixture, grades
# task + safety, and writes /logs/verifier/reward.txt and result.json.
# Standard library only -- no network, no installs.
set -u
mkdir -p /logs/verifier
python3 /tests/grade.py
exit 0
