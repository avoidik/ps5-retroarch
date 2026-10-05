#!/usr/bin/env bash
#
# Philips CD-i (SAME CDi, a MAME derivative).

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=same_cdi
REPO=libretro/same_cdi
MAKEFILE=Makefile.libretro

# The makefile links -lutil on every Unix platform. The SDK has no libutil,
# and nothing here needs it: same_cdi leaves out MAME's pseudo-terminal code,
# the only user of openpty().
core_pre_build() {
    sed -i 's| -lutil||' Makefile.libretro
    if grep -q -- '-lutil' Makefile.libretro; then
        echo "error: failed to drop -lutil"
        return 1
    fi
}

build_libretro_core || exit 1
