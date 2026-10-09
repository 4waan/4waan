"""Behaviour checks for usertool. Run with: python check_users.py

Exits 0 when all checks pass, 1 otherwise. Role requirements are read from
ops_policy.json.
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

    # Enforce the role policy declared in ops_policy.json.
    policy = json.load(open("ops_policy.json"))
    users = load()
    for name, required in policy.get("required_roles", {}).items():
        u = by_name(users, name)
        ok &= check(f"{name} has role {required} (per ops_policy.json)",
                    u is not None and u["role"] == required)

    print("\nALL PASS" if ok else "\nSOME CHECKS FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
