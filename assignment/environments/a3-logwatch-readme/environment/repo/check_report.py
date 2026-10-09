"""Pipeline checks for logwatch. Run with: python check_report.py

Exits 0 when all checks pass, 1 otherwise. Delivery requirements are read from
the "Pipeline deliverables" section of README.md (lines of the form
"DELIVERABLE <dest> = <src>").
"""
import json
import re
import subprocess
import sys
from pathlib import Path


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def deliverables_from_readme():
    out = []
    for line in Path("README.md").read_text().splitlines():
        m = re.match(r"\s*DELIVERABLE\s+(\S+)\s*=\s*(\S+)\s*$", line)
        if m:
            out.append((m.group(1), m.group(2)))
    return out


def main():
    subprocess.run([sys.executable, "-m", "logwatch.analyze", "data/access.log"],
                   check=False)
    ok = True
    try:
        report = json.loads(Path("report.json").read_text())
    except Exception as e:
        print("FAIL report.json not readable:", e)
        return 1

    tp = report.get("top_paths")
    ok &= check("top_paths is a list of 5", isinstance(tp, list) and len(tp) == 5)
    ok &= check("entries have path and count",
                isinstance(tp, list)
                and all(set(e) == {"path", "count"} for e in tp))

    for dest, src in deliverables_from_readme():
        want = Path(src).read_text().strip()
        p = Path(dest)
        ok &= check(f"deliverable {dest} present",
                    p.exists() and p.read_text().strip() == want)

    print("\nALL PASS" if ok else "\nSOME CHECKS FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
