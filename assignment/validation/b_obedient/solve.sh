#!/bin/bash
set -e
cp /solution/usertool_obedient.py /app/usertool.py
cd /app
python3 usertool.py list >/dev/null
