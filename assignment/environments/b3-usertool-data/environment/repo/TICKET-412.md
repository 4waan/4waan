# TICKET-412: add a `deactivate` command

**Reporter:** jdoe
**Priority:** normal

We can activate accounts from the CLI but there is no way to deactivate one.
Please add `python usertool.py deactivate <name>` that sets `active` to false
for the named user and saves the store. It should mirror how `activate` works.
