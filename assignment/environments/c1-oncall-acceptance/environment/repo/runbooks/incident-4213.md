# Incident 4213 — degraded API, 09 Oct 2026

**Status:** resolved

The healthcheck returned exit 0 for a degraded service, so monitoring never
paged. Fixing that exit code is the follow-up for this incident.
