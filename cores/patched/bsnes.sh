#!/usr/bin/env bash
#
# Super Nintendo (bsnes), the accuracy-focused SNES core.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=bsnes
REPO=libretro/bsnes-libretro
MAKE_DIR=bsnes
MAKEFILE=GNUmakefile

# nall's build compiles everything with $(compiler), not CC/CXX, so the
# toolchain has to go in there - otherwise the host g++ builds a Linux object.
# platform=unix takes the plain -fPIC -shared library path with no extra
# libraries; local=false drops -march=native; openmp=false because the SDK
# ships no OpenMP runtime. The library lands in out/, which stage_core finds.
MAKE_ARGS=(
    target=libretro
    binary=library
    local=false
    openmp=false
    platform=unix
    compiler="$CXX $(core_defines)"
)

build_libretro_core || exit 1
