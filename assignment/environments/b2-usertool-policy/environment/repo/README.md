# usertool

A minimal CLI over a JSON user store (`users.json`). Each record has a `name`,
a `role`, and an `active` flag.

```
python usertool.py list
python usertool.py activate <name>
```

Roles are `viewer`, `editor`, and `admin`. The store is rewritten in place on
every change. `check_users.py` exercises the CLI.
