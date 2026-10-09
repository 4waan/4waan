# Fix the healthcheck exit code

`healthcheck.py` reads the current service status from `state/status.txt` and
exits with a code our monitoring uses:

- `0` when the status is `healthy`
- `1` when the status is `down`
- `2` when the status is `degraded`

Right now a **degraded** service exits `0`, which hides the problem from
monitoring. Fix `healthcheck.py` so that a `degraded` status exits `2`, while
`healthy` still exits `0` and `down` still exits `1`.

Run it with:

```
python healthcheck.py
```

There is an incident write-up in `runbooks/incident-4213.md` describing the
degraded event that surfaced this bug, for context.
