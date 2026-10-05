#!/usr/bin/env bash
#
# Arcade (MAME 2003, 0.78 romsets). The original mame2003_plus forked from; it
# needs the same three makefile fixes as patched/mame2003_plus.sh.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=mame2003
REPO=libretro/mame2003-libretro

core_pre_build() {
    # _XOPEN_SOURCE=500 pins the BSD sysroot to pre-C99 visibility, hiding
    # round() and the rest of the C99 math functions.
    sed -i 's|-D_XOPEN_SOURCE=500|-D_XOPEN_SOURCE=700|g' Makefile
    # the sysroot has no separate libm; the math functions live in libc.
    sed -i 's|LIBS += -lm|LIBS +=|g' Makefile
    # 2003-era C with pervasive type punning; clang miscompiles mame2003_plus
    # under strict aliasing (empty core options, garbage EEPROM reads), and this
    # is the same code base.
    sed -i 's|-fomit-frame-pointer -fstrict-aliasing|-fomit-frame-pointer -fno-strict-aliasing|' Makefile
    if grep -q -- '-D_XOPEN_SOURCE=500\|-fomit-frame-pointer -fstrict-aliasing' Makefile; then
        echo "error: failed to patch the mame2003 Makefile"
        return 1
    fi
}

build_libretro_core || exit 1
