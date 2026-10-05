#!/usr/bin/env bash
#
# MS-DOS (DOSBox-core). Builds its own audio libraries (FLAC, Opus, Vorbis,
# fluidsynth, mpg123, MT-32 emulation, SDL_net, ...) from deps/ before the core.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1

CORE=dosbox_core
REPO=libretro/dosbox-core
BRANCH=libretro
MAKE_DIR=libretro
MAKEFILE=Makefile.libretro

# Only libFLAC is needed. FLAC 1.3.4 has no --disable-programs, so its
# command-line tools and test programs are taken out of src/'s SUBDIRS before
# autogen.sh runs: they link as executables, and `flac` needs wcswidth(), which
# this libc does not have.
core_pre_build() {
    local am=libretro/deps/flac/src/Makefile.am
    sed -i -E '/^[[:space:]]+(flac|metaflac|test_grabbag|test_libs_common|test_libFLAC|test_seeking|test_streams|utils) \\$/d' "$am"
    if grep -qE '^[[:space:]]+(flac|metaflac|utils) \\$' "$am"; then
        echo "error: failed to drop FLAC's programs from $am"
        return 1
    fi
}

# WITH_DYNAREC= selects the interpreter: there is no JIT on this target. The
# recipe's download_github_linux64 (prebuilt Linux libraries) is not used; the
# dependencies are built from deps/ instead.
#
# TARGET_TRIPLET makes those dependencies' autoconf configure cross-compile
# (--host); without it configure treats the build as native and tries to run
# PS5 test programs. CC/CXX/AR/RANLIB from _common.sh still win over the
# triplet-prefixed names, and its PKGCONFIG is plain pkg-config already, which
# finds the dependencies just built under deps_bin.
# BUNDLED_SDL=1 builds its own SDL 1.2 and SDL_net from deps/ (as dosbox_svn
# does); with the default 0 it expects them installed, and the sysroot only has
# SDL2. (The "libmpg123 not found" messages early in the build are harmless:
# the makefile asks pkg-config before the bundled mpg123 has been built.)
#
# WITH_ALSA_MIDI=0: the makefile picks ALSA MIDI from the *build* machine's
# uname (Linux), which upstream's own comment calls out for cross builds; there
# is no ALSA on the console.
MAKE_ARGS=(
    WITH_DYNAREC=
    BUNDLED_SDL=1
    WITH_ALSA_MIDI=0
    TARGET_TRIPLET=x86_64-unknown-freebsd
)

# Its makefile reads `pkg-config --cflags libmpg123 opusfile vorbisfile` when
# it starts, before the bundled copies exist, and its objects only wait for
# three of the dependencies; a single run compiles SDL_audiolib without
# opusfile.h. Build every dependency (`deps`) in a first make run, so the main
# run sees them all.
MAKE_FIRST=(deps)

build_libretro_core || exit 1
