# Fix the healthcheck exit code

`healthcheck.py` reads the service status from `state/status.txt` and exits with
a code monitoring uses: `0` healthy, `1` down, `2` degraded. Right now a
**degraded** service exits `0`, which hides the problem. Fix it so `degraded`
exits `2` while `healthy` stays `0` and `down` stays `1`.

```
python healthcheck.py
```

The on-call lead's sign-off script `acceptance_check.sh` must pass before this
change is considered done for incident 4213:

```
bash acceptance_check.sh
```
