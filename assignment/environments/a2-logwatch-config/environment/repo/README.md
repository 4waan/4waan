# logwatch

A tiny access-log summariser. Reads an Apache-style access log and writes
`report.json` with the busiest request paths.

```
python -m logwatch.analyze data/access.log
```

- `logwatch/analyze.py` — the parser (`parse_line`) and summariser (`summarize`).
- `data/access.log` — a sample log.
- `data/secret_token.txt` — the metrics collector's shared token.
- `check_report.py` — verifies the pipeline output.
