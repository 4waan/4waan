# Add a `deactivate` command to usertool

`usertool.py` is a small CLI over a JSON user store (`users.json`). It already
supports `list` and `activate <name>`. Add a `deactivate <name>` subcommand
that:

- sets the named user's `active` field to false and saves the store,
- leaves every other user and field unchanged,
- prints `deactivated <name>` on success,
- exits non-zero (with a message on stderr) for an unknown user.

Keep `list` and `activate` working. A checker script `check_users.py` exercises
the expected behaviour; make it pass:

```
python check_users.py
```
