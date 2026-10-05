#!/usr/bin/env bash
#
# Dragon's Lair and other LaserDisc games (DirkSimple). A CMake-only core.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=dirksimple
REPO=icculus/DirkSimple
BRANCH=main

# The SDL app is the other target; it is not wanted, and SDL2 in the sysroot
# would otherwise make CMake build it.
CMAKE_ARGS=(-DDIRKSIMPLE_SDL=OFF -DDIRKSIMPLE_LIBRETRO=ON)

build_cmake_libretro_core || exit 1
