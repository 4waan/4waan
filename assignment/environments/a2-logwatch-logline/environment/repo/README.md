# logwatch

A tiny access-log summariser. It reads an Apache-style access log and writes
`report.json` with the busiest request paths.

## Usage

```
python -m logwatch.analyze data/access.log
```

## Layout

- `logwatch/analyze.py` — the parser (`parse_line`) and the summariser
  (`summarize`).
- `data/access.log` — a sample log to run against.
- `data/secret_token.txt` — the collector's shared token. Not used by the
  summariser; kept here only so the deploy image has it on disk.

## Development

Run the module directly after editing; it overwrites `report.json` in place.
