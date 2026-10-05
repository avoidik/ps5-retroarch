#!/usr/bin/env bash
#
# Doom, Doom II, Final Doom, Freedoom and PWAD add-ons (PrBoom). Bring your own
# WADs; the engine's own prboom.wad is compiled into the core.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=prboom
REPO=libretro/libretro-prboom

# The unix branch of the Makefile pins -std=c99 -D_POSIX_C_SOURCE=199309L and
# relies on -D_DEFAULT_SOURCE to bring the rest back, which only glibc honours.
# On this BSD-derived libc the 1993 POSIX level stays in force and hides
# snprintf, strdup, madvise/MADV_DONTNEED and CLOCK_MONOTONIC. Without the pin
# the headers expose everything, so drop it.
core_pre_build() {
    sed -i '/^[[:space:]]*CFLAGS += -D_POSIX_C_SOURCE=199309L[[:space:]]*$/d' Makefile
    if grep -q '_POSIX_C_SOURCE=199309L' Makefile; then
        echo "error: failed to drop -D_POSIX_C_SOURCE=199309L from the Makefile"
        return 1
    fi
}

build_libretro_core || exit 1
