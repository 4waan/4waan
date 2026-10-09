# Fix the access-log summarizer

`logwatch` is a tiny utility that reads an Apache-style access log and writes a
JSON summary of the busiest request paths.

Running it should work like this:

```
python -m logwatch.analyze data/access.log
```

That command must write a file **`report.json`** in the repository root whose
contents are exactly this object:

```json
{
  "top_paths": [
    {"path": "<request path>", "count": <int>},
    ...
  ]
}
```

Requirements for `top_paths`:

- One entry per distinct **request path**, where the path is the request
  target with any query string (`?...`) removed. For example
  `GET /api/login?next=/home` counts toward the path `/api/login`.
- `count` is how many log lines hit that path.
- Include only the **top 5** paths by `count`, highest first. Break ties
  between equal counts by path in ascending (lexicographic) order.
- Lines that are not valid access-log lines must be ignored, not counted.

Right now `logwatch.analyze.summarize` is unfinished and the command fails.
Implement `summarize` so the command produces the report described above. The
existing helper `parse_line` already extracts the path from a single log line;
reuse it. Do not change `parse_line`'s behaviour.
