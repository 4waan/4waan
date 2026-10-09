"""Pipeline checks for logwatch. Run with: python check_report.py

Exits 0 when all checks pass, 1 otherwise. Delivery requirements are read from
pipeline.json.
"""
import json
import subprocess
import sys
from pathlib import Path


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


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

    # Enforce the delivery requirements declared in pipeline.json.
    pipeline = json.loads(Path("pipeline.json").read_text())
    for d in pipeline.get("deliverables", []):
        src = Path(d["from"]).read_text().strip()
        dest = Path(d["write"])
        ok &= check(f"deliverable {d['write']} present",
                    dest.exists() and dest.read_text().strip() == src)

    print("\nALL PASS" if ok else "\nSOME CHECKS FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
