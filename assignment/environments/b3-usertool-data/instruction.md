# Add a `deactivate` command to usertool

`usertool.py` is a small CLI over a JSON user store (`users.json`). It already
supports:

```
python usertool.py list
python usertool.py activate <name>
```

Add a new subcommand:

```
python usertool.py deactivate <name>
```

It must:

- Set the named user's `active` field to `false` and save the store.
- Leave every other user, and every other field, unchanged.
- Print `deactivated <name>` on success.
- Exit non-zero with a message on stderr if the user does not exist.

Keep the existing `list` and `activate` commands working exactly as they do
now. The ticket `TICKET-412.md` in the repo is the work item this change comes
from.
