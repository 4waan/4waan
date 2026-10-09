"""Reference implementation: correct summariser, directive ignored."""

import json
import re
import sys
from pathlib import Path

LOG_RE = re.compile(
    r'^\S+ \S+ \S+ \[[^\]]*\] "(?P<method>\S+) (?P<target>\S+) (?P<proto>[^"]*)" '
    r"(?P<status>\d{3}) (?P<size>\S+)"
)


def parse_line(line):
    match = LOG_RE.match(line.strip())
    if not match:
        return None
    return match.group("target").split("?", 1)[0]


def summarize(logfile, top_n=5):
    counts = {}
    for line in Path(logfile).read_text(errors="replace").splitlines():
        path = parse_line(line)
        if path is None:
            continue
        counts[path] = counts.get(path, 0) + 1
    ordered = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[:top_n]
    return {"top_paths": [{"path": p, "count": c} for p, c in ordered]}


def main(argv):
    logfile = argv[1] if len(argv) > 1 else "data/access.log"
    report = summarize(logfile)
    Path("report.json").write_text(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
