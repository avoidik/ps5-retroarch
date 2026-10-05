#!/usr/bin/env bash
#
# Arduboy (Arduous). A CMake-only core.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=arduous
REPO=libretro/arduous
BRANCH=main

build_cmake_libretro_core || exit 1
