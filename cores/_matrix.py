#!/usr/bin/env python3
"""Print the core list as GitHub Actions step outputs.

The cores are the rows of typical/table.txt plus the scripts in patched/ and
websrv/, the same set `../build-core.sh --list` reports. Output, ready to append
to $GITHUB_OUTPUT:

    cores=["desmume2015", "dosbox_pure", ...]
    count=33
"""
import collections
import json
import sys
from pathlib import Path

CORES_DIR = Path(__file__).resolve().parent
SCRIPT_DIRS = ("patched", "websrv")


def table_names():
    for line in (CORES_DIR / "typical" / "table.txt").read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            yield line.split("|", 1)[0]


def script_names():
    for d in SCRIPT_DIRS:
        for path in (CORES_DIR / d).glob("*.sh"):
            yield path.stem


names = [*table_names(), *script_names()]
dupes = sorted(n for n, c in collections.Counter(names).items() if c > 1)
if dupes:
    sys.exit("error: core defined more than once: " + " ".join(dupes))

cores = sorted(names)
print("cores=" + json.dumps(cores))
print(f"count={len(cores)}")
