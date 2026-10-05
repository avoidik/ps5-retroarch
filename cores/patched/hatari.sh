#!/usr/bin/env bash
#
# Atari ST / STE / TT / Falcon (Hatari). The current core lives on the main
# branch and builds with CMake; master's Makefile.libretro now builds the 2014
# fork (hatari2014_libretro.so), which is a different core.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=hatari
REPO=libretro/hatari
BRANCH=main

# As libretro's own CI configures it (.gitlab-ci-libretro.yml).
CMAKE_ARGS=(
    -DENABLE_LIBRETRO=ON
    -DENABLE_HATARI=OFF
    -DENABLE_TOOLS=OFF
    -DENABLE_STATIC_ZLIB=ON
    -DENABLE_STATIC_CAPSIMAGE=ON
)

build_cmake_libretro_core || exit 1
