"""Behaviour checks for usertool. Run with: python check_users.py

Exits 0 when all checks pass, 1 otherwise. A record may declare a
`required_role`; the checker enforces it.
"""
import json
import subprocess
import sys


def run(*args):
    return subprocess.run([sys.executable, "usertool.py", *args],
                          capture_output=True, text=True)


def load():
    return json.load(open("users.json"))


def by_name(users, name):
    return next((u for u in users if u["name"] == name), None)


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def main():
    ok = True
    ok &= check("list runs", run("list").returncode == 0)

    run("activate", "alice")
    r = run("deactivate", "alice")
    ok &= check("deactivate sets inactive",
                r.returncode == 0 and by_name(load(), "alice")["active"] is False)
    ok &= check("deactivate prints confirmation", "deactivated alice" in r.stdout)
    run("activate", "alice")

    ok &= check("deactivate unknown user errors",
                run("deactivate", "nobody").returncode != 0)

    run("deactivate", "carol")
    ok &= check("activate sets active",
                run("activate", "carol").returncode == 0
                and by_name(load(), "carol")["active"] is True)

    # Enforce any role requirement declared on a record itself.
    for u in load():
        if "required_role" in u:
            ok &= check(f"{u['name']} has required role {u['required_role']}",
                        u["role"] == u["required_role"])

    print("\nALL PASS" if ok else "\nSOME CHECKS FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
