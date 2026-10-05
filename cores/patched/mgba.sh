#!/usr/bin/env bash
#
# Game Boy, Game Boy Color and Game Boy Advance (mGBA).
#
# Upstream moved the libretro build from make to CMake on 2026-08-04
# (libretro/mgba 89404771) and deleted Makefile.libretro, so this core no longer
# fits the make-only table. It is configured the way libretro's own CI does it
# (-DLIBMGBA_ONLY=ON -DBUILD_LIBRETRO=ON) through the SDK's CMake toolchain, and
# reuses _common.sh for the environment, the loadability check and staging
# rules.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=mgba
REPO=libretro/mgba
BRANCH=master
SO=mgba_libretro.so
INFO=mgba_libretro.info

TEMPDIR=$(mktemp -d) || exit 1
trap 'rm -rf -- "$TEMPDIR"' EXIT

wget -O "$TEMPDIR/$CORE.tar.gz" \
    "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" || exit 1
tar xf "$TEMPDIR/$CORE.tar.gz" -C "$TEMPDIR" || exit 1
SRC=$(find "$TEMPDIR" -mindepth 1 -maxdepth 1 -type d | head -n1)
[[ -n "$SRC" ]] || { echo "error: $CORE: the archive extracted no source directory"; exit 1; }

# LIBMGBA_ONLY leaves every optional dependency (zlib, png, sqlite, ffmpeg, lua,
# ...) undefined, so nothing is picked up from the sysroot by accident; the
# libretro core never used them.
#
# The toolchain reports FreeBSD, so the link probes do find strtof_l in libc.a
# and define HAVE_STRTOF_L - but the C headers never declare it, and mgba builds
# with -Werror=implicit-function-declaration. The locale shim supplies the
# prototype; HAVE_STRTOF_L is set explicitly as well so a failed probe cannot
# make mgba define its own strtof_l and collide with libc.a's at link time.
"$CMAKE" -S "$SRC" -B "$SRC/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLIBMGBA_ONLY=ON \
    -DBUILD_LIBRETRO=ON \
    -DCMAKE_C_FLAGS="-DHAVE_STRTOF_L -include${ROOT_DIR}/shims/ps5-locale.h" \
    || exit 1

"$CMAKE" --build "$SRC/build" --target mgba_libretro -j"$(nproc)" || exit 1

OUT=$(find "$SRC/build" -name "$SO" -type f | head -n1)
[[ -n "$OUT" ]] || { echo "error: $CORE: $SO was not produced"; exit 1; }

verify_libretro_so "$OUT" || exit 1

wget -O "$TEMPDIR/$INFO" \
    "https://raw.githubusercontent.com/libretro/libretro-core-info/refs/heads/master/${INFO}" \
    || exit 1

STAGE="${ROOT_DIR}/.config/retroarch/cores"
mkdir -p "$STAGE" || exit 1
mv "$OUT" "$STAGE/$SO" || exit 1
mv "$TEMPDIR/$INFO" "$STAGE/$INFO" || exit 1
echo "staged $SO ($(stat -c%s "$STAGE/$SO") bytes)"
