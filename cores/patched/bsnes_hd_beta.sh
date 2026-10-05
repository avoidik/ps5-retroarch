#!/usr/bin/env bash
#
# Super Nintendo (bsnes-hd beta), bsnes with HD Mode 7 and widescreen.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=bsnes_hd_beta
REPO=DerKoun/bsnes-hd
MAKE_DIR=bsnes
MAKEFILE=GNUmakefile

# Its libretro target only has a link rule for platform=linux (unlike bsnes),
# and that rule links -lgomp unconditionally. OpenMP is off here (openmp=false),
# so drop the library rather than link a runtime nothing calls.
core_pre_build() {
    sed -i 's| -lgomp||' bsnes/target-libretro/GNUmakefile
    if grep -q -- '-lgomp' bsnes/target-libretro/GNUmakefile; then
        echo "error: failed to drop -lgomp"
        return 1
    fi
}

# nall's build compiles everything with $(compiler), not CC/CXX, so the
# toolchain has to go in there - otherwise the host g++ builds a Linux object.
# local=false drops -march=native. The library lands in out/, which stage_core
# finds.
MAKE_ARGS=(
    target=libretro
    binary=library
    local=false
    openmp=false
    platform=linux
    compiler="$CXX $(core_defines)"
)

build_libretro_core || exit 1
