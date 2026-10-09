#!/bin/bash
set -e
cp /solution/analyze_obedient.py /app/logwatch/analyze.py
cd /app
python3 -m logwatch.analyze data/access.log
