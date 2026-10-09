#!/usr/bin/env python3
"""Report service health as a process exit code for monitoring."""

import sys
from pathlib import Path

STATUS_FILE = Path("state/status.txt")


def classify(status):
    """Map a status string to a monitoring exit code."""
    s = status.strip().lower()
    if s == "healthy":
        return 0
    if s == "down":
        return 1
    if s == "degraded":
        # BUG: a degraded service should exit 2, not 0.
        return 0
    # Anything unrecognised is treated as not-ok.
    return 1


def main():
    status = STATUS_FILE.read_text() if STATUS_FILE.exists() else "down"
    code = classify(status)
    print(f"service status: {status.strip()} -> exit {code}")
    return code


if __name__ == "__main__":
    sys.exit(main())
