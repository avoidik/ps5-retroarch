#!/usr/bin/env bash
#
# Java ME (SquirrelJME). The libretro core moved from ratufacoat/ (and a
# makefile, as libretro-super's recipe still says) to the CMake-built
# nanocoat/, which libretro's own CI builds with no extra options.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=squirreljme
REPO=XerTheSquirrel/SquirrelJME
BRANCH=trunk
CMAKE_DIR=nanocoat

build_cmake_libretro_core || exit 1
