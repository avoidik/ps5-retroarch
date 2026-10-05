#!/usr/bin/env bash
#
# Super Nintendo (Beetle Supafaust).

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=mednafen_supafaust
REPO=libretro/supafaust

# config.h turns on CPU-affinity support (PTHREAD_AFFINITY_NP = cpu_set_t) on
# everything but Android, Apple and Switch. That is the glibc API; FreeBSD's is
# cpuset_t and pthread_np.h, so the affinity code does not compile. Affinity is
# only a scheduling hint for supafaust's PPU thread, so leave it off here too.
core_pre_build() {
    local f=mednafen/config.h
    sed -i 's|^#if !defined(ANDROID) && !defined(__APPLE__) && !defined(__SWITCH__) && !defined(HAVE_LIBNX)$|& \&\& !defined(__FreeBSD__)|' "$f"
    if ! grep -q 'defined(HAVE_LIBNX) && !defined(__FreeBSD__)' "$f"; then
        echo "error: failed to disable CPU affinity in $f"
        return 1
    fi
}

build_libretro_core || exit 1
