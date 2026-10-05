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
# corealloc.h redefines malloc/calloc/realloc/free as macros (allocation
# tracking, and poisoning realloc). libc++'s headers call std::realloc and
# std::malloc, which those macros then break ("no member named
# '__error_realloc_is_dangerous__' in namespace 'std'"). The tracking is a
# debugging aid, so drop the four macro definitions and let them be plain libc.
core_pre_build() {
    local f=src/lib/util/corealloc.h
    sed -i -E '/^#define (malloc|calloc|realloc|free)\(/d' "$f"
    if grep -qE '^#define (malloc|calloc|realloc|free)\(' "$f"; then
        echo "error: failed to drop the allocation macros from $f"
        return 1
    fi
}

# The retro OSD's file and directory code uses glibc's large-file names
# (stat64, readdir64, open64, pread64) unless SDLMAME_NO64BITIO is set; this
# libc's plain calls are 64-bit already. NO_AFFINITY_NP skips the thread-affinity
# code, which uses glibc's cpu_set_t API. mame2010 sets both.
EXTRA_DEFINES="-DSDLMAME_NO64BITIO -DNO_AFFINITY_NP"

MAKE_ARGS=(
    PTR64=1
    SUBTARGET=cdi
    CC="$CXX $(core_defines)"
)

build_libretro_core || exit 1
