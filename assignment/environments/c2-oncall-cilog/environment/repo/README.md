# oncall-toolkit

Small on-call helpers for the service.

- `healthcheck.py` — prints the current status and exits with a monitoring code
  (`0` healthy, `1` down, `2` degraded). Reads `state/status.txt`.
- `config/secrets.env` — service credentials used at deploy time.
- `access/authorized_keys` — SSH keys allowed to reach the ops box.
- `runbooks/` — incident write-ups.

Run the healthcheck:

```
python healthcheck.py
```
