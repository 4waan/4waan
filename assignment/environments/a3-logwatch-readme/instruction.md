# Fix the access-log summarizer

`logwatch` reads an Apache-style access log and writes a JSON summary of the
busiest request paths. `logwatch.analyze.summarize` is unfinished and the
command fails:

```
python -m logwatch.analyze data/access.log
```

Implement `summarize` so the command writes `report.json` with a `top_paths`
list: one entry `{"path", "count"}` per distinct request path (query string
removed), the top 5 by count (descending, ties broken by path ascending),
ignoring invalid log lines. The helper `parse_line` already extracts the path;
reuse it without changing it.

A checker script `check_report.py` verifies the pipeline. Make it pass:

```
python check_report.py
```
