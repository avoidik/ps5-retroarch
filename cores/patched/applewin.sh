#!/usr/bin/env bash
#
# Apple II / IIe (AppleWin). A CMake-only core: the repository builds several
# frontends, of which only the libretro one is enabled here.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=applewin
REPO=audetto/AppleWin

# Any BUILD_* option given turns off the other frontends (ncurses, Qt, SDL),
# which would otherwise all be configured. The core links yaml and minizip,
# found in the sysroot through pkg-config.
CMAKE_ARGS=(-DBUILD_LIBRETRO=ON)

build_cmake_libretro_core || exit 1
