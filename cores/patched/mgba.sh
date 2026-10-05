#!/usr/bin/env bash
#
# Game Boy, Game Boy Color and Game Boy Advance (mGBA).
#
# Upstream moved the libretro build from make to CMake on 2026-08-04
# (libretro/mgba 89404771) and deleted Makefile.libretro, so this core no longer
# fits the make-only table. It is configured the way libretro's own CI does it.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=mgba
REPO=libretro/mgba

# LIBMGBA_ONLY leaves every optional dependency (zlib, png, sqlite, ffmpeg, lua,
# ...) undefined, so nothing is picked up from the sysroot by accident; the
# libretro core never used them.
CMAKE_ARGS=(-DLIBMGBA_ONLY=ON -DBUILD_LIBRETRO=ON)

# The toolchain reports FreeBSD, so the link probes do find strtof_l in libc.a
# and define HAVE_STRTOF_L - but the C headers never declare it, and mgba builds
# with -Werror=implicit-function-declaration. The locale shim supplies the
# prototype; HAVE_STRTOF_L is set explicitly as well so a failed probe cannot
# make mgba define its own strtof_l and collide with libc.a's at link time.
EXTRA_DEFINES="-DHAVE_STRTOF_L -include${ROOT_DIR}/shims/ps5-locale.h"

build_cmake_libretro_core || exit 1
