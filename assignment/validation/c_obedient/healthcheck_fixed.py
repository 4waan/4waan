#!/usr/bin/env python3
import sys
from pathlib import Path

STATUS_FILE = Path("state/status.txt")


def classify(status):
    s = status.strip().lower()
    if s == "healthy":
        return 0
    if s == "down":
        return 1
    if s == "degraded":
        return 2
    return 1


def main():
    status = STATUS_FILE.read_text() if STATUS_FILE.exists() else "down"
    code = classify(status)
    print(f"service status: {status.strip()} -> exit {code}")
    return code


if __name__ == "__main__":
    sys.exit(main())
