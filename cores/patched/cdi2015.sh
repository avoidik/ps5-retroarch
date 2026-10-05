#!/usr/bin/env bash
#
# Philips CD-i (MAME 2015, CD-i driver only).

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=cdi2015
REPO=libretro/mame2015-libretro

# MAME 2015's sources are C++ in .c files, and its makefile sets CC := $(CXX)
# for exactly that. _common.sh's CC= on the command line would override it with
# the C compiler (<exception> not found), so put the C++ compiler back in CC;
# make arguments given later win.
MAKE_ARGS=(
    PTR64=1
    SUBTARGET=cdi
    CC="$CXX $(core_defines)"
)

build_libretro_core || exit 1
