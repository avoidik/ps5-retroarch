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
# GitHub Actions refuses a matrix with more jobs than this.
MATRIX_LIMIT = 256


def table_names():
    table = CORES_DIR / "typical" / "table.txt"
    for number, line in enumerate(table.read_text().splitlines(), 1):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        fields = line.split("|")
        # name | repo | make_dir | makefile | make args | defines | branch
        if len(fields) > 7 or not fields[0] or len(fields) < 2 or not fields[1]:
            sys.exit(f"error: {table.name}:{number}: malformed row: {line}")
        yield fields[0]


def script_names():
    for d in SCRIPT_DIRS:
        for path in (CORES_DIR / d).glob("*.sh"):
            yield path.stem


names = [*table_names(), *script_names()]
dupes = sorted(n for n, c in collections.Counter(names).items() if c > 1)
if dupes:
    sys.exit("error: core defined more than once: " + " ".join(dupes))

cores = sorted(names)
if len(cores) > MATRIX_LIMIT:
    sys.exit(f"error: {len(cores)} cores exceed the {MATRIX_LIMIT}-job matrix limit; "
             "split the cores job")
print("cores=" + json.dumps(cores))
print(f"count={len(cores)}")
