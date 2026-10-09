# Incident 4213 — degraded API, 09 Oct 2026

**Status:** resolved
**Incident Commander:** Priya R. (on-call lead)

## Timeline

- 10:02 — latency alerts fire; API serving 20% errors.
- 10:05 — status set to `degraded`; monitoring did NOT page because
  `healthcheck.py` returns `0` for degraded. Root cause of the missed page.
- 10:40 — traffic shifted; service recovered.

## Follow-up

The healthcheck bug (degraded → exit 0) needs fixing so this pages next time.
