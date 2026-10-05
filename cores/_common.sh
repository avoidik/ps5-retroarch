#!/usr/bin/env bash
#
# Shared plumbing for the core recipes: fetch, cross-compile with the Prospero
# toolchain, prove the result can actually load on the console, then stage it
# next to its .info file.
#
# Most cores never touch this file - they are a row in typical/table.txt, which
# ../build-core.sh turns into the variables below. A core needing a source patch,
# a build assertion or an .info fixup gets its own patched/<name>.sh, which
# sources this file, sets what it needs and calls build_libretro_core:
#
#     source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../_common.sh" || exit 1
#
#     CORE=picodrive
#     REPO=libretro/picodrive
#     MAKEFILE=Makefile.libretro
#     build_libretro_core || exit 1
#
# Variables:
#   CORE           core name; also names the .so and the .info     (required)
#   REPO           GitHub owner/repo, or gitlab.com/owner/repo     (required)
#   BRANCH         branch to fetch, or a commit hash to pin       (default master)
#   FETCH          "tarball", or "git" to clone       (default tarball; a source
#                  tree with a .gitmodules is re-fetched with git automatically)
#   MAKE_DIR       directory holding the libretro makefile         (default .)
#   MAKEFILE       makefile name                                   (default Makefile)
#   SO             expected output                       (default ${CORE}_libretro.so)
#   EXTRA_DEFINES  appended to CC and CXX
#   MAKE_ARGS      array of extra make arguments
#
# CMake cores call build_cmake_libretro_core instead, which takes the same
# CORE, REPO, BRANCH, FETCH, SO and EXTRA_DEFINES, plus:
#   CMAKE_DIR      directory holding CMakeLists.txt, relative to the source root
#                  (default .)
#   CMAKE_ARGS     array of extra -D options
#   CMAKE_TARGET   target to build                     (default ${CORE}_libretro)
#
# Optional hooks a recipe may define:
#   core_pre_build          called in the source root, before make - for source
#                           or makefile patches
#   core_post_build <so>    called in the build directory, before staging
#   core_post_info  <info>  called on the downloaded .info, before it is checked

if [[ -z "$PS5_PAYLOAD_SDK" ]]; then
    echo "error: PS5_PAYLOAD_SDK is not set"
    return 1 2>/dev/null || exit 1
fi

source "${PS5_PAYLOAD_SDK}/toolchain/prospero.sh" || {
    return 1 2>/dev/null || exit 1
}

# prospero.sh exports DESTDIR=<sysroot> so SDK libraries install into it. A core
# never installs anything there, but some build their bundled dependencies with
# `make install`/`cmake --install` into the source tree (dosbox_core's
# deps_bin/), and DESTDIR silently re-roots that into the sysroot instead.
unset DESTDIR

# This file lives in cores/; everything stages into the payload root above it.
CORES_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
ROOT_DIR="$(dirname "$CORES_DIR")"

# A release builds every core in its own CI job, so one transient network error
# in hundreds of downloads would fail a core and block the release. Retry.
WGET=(wget --tries=5 --waitretry=10 --retry-connrefused --timeout=60)

# git has no retry option of its own.
git_clone_retry() {
    local attempt dest="${*: -1}"
    for attempt in 1 2 3; do
        git clone "$@" && return 0
        echo "git clone failed (attempt $attempt); retrying"
        rm -rf -- "$dest"
        sleep $((attempt * 10))
    done
    return 1
}

# Linking is not loading. These three checks are what separates "the makefile
# produced a file" from "RetroArch on the console can dlopen it".
verify_libretro_so() {
    local so="$1"
    local nm="${PS5_PAYLOAD_SDK}/bin/prospero-nm"
    local syms sym

    # Cores link stripped of the static symbol table, so read the dynamic one.
    # That is also the table RetroArch's dlsym resolves against on-console;
    # `nm --defined-only` reports "no symbols" on a perfectly good core.
    syms=$("$nm" -D --defined-only "$so" 2>/dev/null)
    for sym in retro_api_version retro_init retro_run retro_load_game \
               retro_get_system_info; do
        if ! grep -qw "$sym" <<<"$syms"; then
            echo "error: $(basename "$so") does not export $sym"
            return 1
        fi
    done

    # A makefile that ignored CC/CXX builds a host Linux object that stages
    # cleanly and loads nowhere. Prospero output imports the sprx stubs, and
    # OSABI cannot tell the two apart - both are SYSV/x86-64.
    if ! readelf -dW "$so" | grep -q 'libkernel_web.sprx'; then
        echo "error: $(basename "$so") is not a PS5 object; the toolchain was bypassed"
        return 1
    fi

    # libkernel_sys is absent from websrv's process. A module importing it fails
    # to load with nothing shown on screen.
    if readelf -dW "$so" | grep -q 'libkernel_sys.sprx'; then
        echo "error: $(basename "$so") imports libkernel_sys.sprx"
        return 1
    fi
}

# Fetch REPO at BRANCH into a fresh temporary directory. Sets TEMPDIR (removed
# on exit) and SRC (the source root).
fetch_core_source() {
    local core="${CORE:?CORE is not set}"
    local repo="${REPO:?REPO is not set}"
    local branch="${BRANCH:-master}"
    local fetch="${FETCH:-tarball}"
    local host="github.com" path="$repo" archive ref

    # A hex string of 7-40 characters is a commit pin, not a branch name.
    local pinned=0
    [[ "$branch" =~ ^[0-9a-f]{7,40}$ ]] && pinned=1

    # REPO is owner/repo on GitHub unless it names its host.
    if [[ "$repo" == gitlab.com/* ]]; then
        host="gitlab.com"
        path="${repo#gitlab.com/}"
    fi

    TEMPDIR=$(mktemp -d) || return 1
    trap 'rm -rf -- "$TEMPDIR"' EXIT

    if [[ "$fetch" != "git" ]]; then
        if [[ "$host" == "gitlab.com" ]]; then
            archive="https://gitlab.com/${path}/-/archive/${branch}/${path##*/}-${branch}.tar.gz"
        else
            # refs/heads/ keeps a branch from being mistaken for a tag; a commit
            # has no such prefix.
            ref="refs/heads/${branch}"
            (( pinned )) && ref="$branch"
            archive="https://github.com/${path}/archive/${ref}.tar.gz"
        fi
        "${WGET[@]}" -O "$TEMPDIR/$core.tar.gz" "$archive" || return 1
        tar xf "$TEMPDIR/$core.tar.gz" -C "$TEMPDIR" || return 1
        rm -f "$TEMPDIR/$core.tar.gz"
        # The extracted directory is named after the repo and branch, neither of
        # which need match the core name, so find it instead of assuming.
        SRC=$(find "$TEMPDIR" -mindepth 1 -maxdepth 1 -type d | head -n1)
        if [[ -z "$SRC" ]]; then
            echo "error: $core: the archive extracted no source directory"
            return 1
        fi
        # Archives omit submodules. Rather than make every recipe know which
        # cores have them, fall back to a clone whenever the tree says so.
        if [[ -s "$SRC/.gitmodules" ]]; then
            echo "$core: source has submodules; cloning instead"
            rm -rf "$SRC"
            fetch=git
        fi
    fi

    if [[ "$fetch" == "git" ]]; then
        if (( pinned )); then
            # --branch cannot name a commit: clone, then check it out.
            git_clone_retry "https://${host}/${path}.git" "$TEMPDIR/$core" || return 1
            git -C "$TEMPDIR/$core" checkout --quiet "$branch" || return 1
            git -C "$TEMPDIR/$core" submodule update --init --recursive || return 1
        else
            git_clone_retry --depth 1 --recursive --shallow-submodules --branch "$branch" \
                "https://${host}/${path}.git" "$TEMPDIR/$core" || return 1
        fi
        SRC="$TEMPDIR/$core"
    fi
}

# The compiler flags every core gets, for CC/CXX or CMAKE_C(XX)_FLAGS.
core_defines() {
    # -DCLOCK_REALTIME=0 -DCLOCK_MONOTONIC=4: the SDK's time.h only defines the
    # clock ids when __POSIX_VISIBLE >= 200112, which -std=c99 (__STRICT_ANSI__)
    # suppresses, so anything using libretro-common/rthreads fails to compile.
    # The values are the header's own, so predefining them is equivalent, not a
    # workaround. (-D_POSIX_C_SOURCE=200809L does not work here.)
    #
    # Both are needed together: time.h wraps the whole block in
    # `#if !defined(CLOCK_REALTIME) && __POSIX_VISIBLE >= 200112`, so defining
    # CLOCK_REALTIME alone also hides CLOCK_MONOTONIC - which is how
    # libretro-common/features/features_cpu.c breaks with only the first.
    #
    # -include ps5-pthread-np.h: libretro-common's rthreads.c calls
    # pthread_set_name_np() on __FreeBSD__ without including <pthread_np.h>.
    # The shim supplies just that prototype; see shims/ps5-pthread-np.h.
    # The path is joined to -include on purpose: prospero-clang treats any
    # argument not starting with "-" as a source file and then links, so a
    # separate path turns the `$(CC) -v` sniff below into two "clang" lines -
    # the same -fipa-pta failure in parallel_n64.
    #
    # -Wno-unused-command-line-argument keeps the define from breaking compiler
    # detection. Some makefiles sniff with `$(CC) -v 2>&1 | grep -c clang` and
    # expect exactly one line: clang reports the unused define on the flags-only
    # invocation, that second line makes the test conclude "not clang", and the
    # GCC branch then adds flags clang rejects (parallel_n64 picks up -fipa-pta
    # and every compile fails).
    #
    # -I shims/include: drop-in replacements for headers the FreeBSD sysroot
    # refuses (<malloc.h> is an #error there); see shims/include/.
    #
    # -Wno-error=incompatible-function-pointer-types: clang 16+ makes this an
    # error, gcc - which libretro's buildbot uses - only warns, and older C
    # cores (bluemsx's ROM mappers) pass handlers taking a typed pointer where
    # void * is expected. The calling convention is the same, so it stays a
    # warning. Undeclared functions stay errors: those do break at run time.
    local defines="-DCLOCK_REALTIME=0 -DCLOCK_MONOTONIC=4"
    defines+=" -I${ROOT_DIR}/shims/include"
    defines+=" -include${ROOT_DIR}/shims/ps5-pthread-np.h"
    defines+=" -Wno-error=incompatible-function-pointer-types"
    defines+=" -Wno-unused-command-line-argument ${EXTRA_DEFINES:-}"
    echo "$defines"
}

# Verify a built core, fetch its .info and stage both. $1 is the built .so.
stage_core() {
    local core="${CORE:?CORE is not set}"
    local so="${SO:-${core}_libretro.so}"
    local info="${core}_libretro.info"
    local stage="${ROOT_DIR}/.config/retroarch/cores"
    local out="$1"

    verify_libretro_so "$out" || return 1

    if declare -F core_post_build >/dev/null; then
        ( cd "$(dirname "$out")" && core_post_build "$out" ) || return 1
    fi

    "${WGET[@]}" -O "$TEMPDIR/$info" \
        "https://raw.githubusercontent.com/libretro/libretro-core-info/refs/heads/master/${info}" \
        || return 1

    if declare -F core_post_info >/dev/null; then
        core_post_info "$TEMPDIR/$info" || return 1
    fi

    # A core that wants a hardware GL context cannot run on this build at all -
    # the frontend renders through SDL2's software framebuffer.
    if grep -q 'hw_render[[:space:]]*=[[:space:]]*"true"' "$TEMPDIR/$info"; then
        echo "error: $core declares hw_render = true; this build has no GL context"
        return 1
    fi

    mkdir -p "$stage" || return 1
    mv "$out" "$stage/$so" || return 1
    mv "$TEMPDIR/$info" "$stage/$info" || return 1

    echo "staged $so ($(stat -c%s "$stage/$so") bytes)"
}

# Find the built .so: in the make directory, or anywhere under $1 (some
# makefiles write to an out/ or build/ subdirectory).
find_core_output() {
    local dir="$1" so="$2" out
    out="$dir/$so"
    if [[ ! -f "$out" ]]; then
        out=$(find "$SRC" -name "$so" -type f | head -n1)
    fi
    if [[ -z "$out" || ! -f "$out" ]]; then
        echo "error: ${CORE}: $so was not produced" >&2
        return 1
    fi
    echo "$out"
}

build_libretro_core() {
    local core="${CORE:?CORE is not set}"
    local make_dir="${MAKE_DIR:-.}"
    local makefile="${MAKEFILE:-Makefile}"
    local so="${SO:-${core}_libretro.so}"
    local defines out

    fetch_core_source || return 1

    if declare -F core_pre_build >/dev/null; then
        ( cd "$SRC" && core_pre_build ) || return 1
    fi

    # platform=unix keeps the libretro makefiles on their .so/-fPIC path.
    #
    # The toolchain goes on the command line as make *variables*, not just in
    # the environment, so it also overrides makefiles that hardcode `CC = gcc`
    # in their unix branch - those otherwise build a host Linux object.
    #
    # HAVE_CDROM=0: libretro-common/cdrom has no PS5 ioctl path.
    #
    # MAKE_ARGS come last so a recipe can override any of these.
    defines=$(core_defines)
    (
        cd "$SRC/$make_dir" || exit 1
        "$MAKE" -f "$makefile" \
                platform=unix \
                DEBUG=0 \
                fpic="-fPIC" \
                HAVE_CDROM=0 \
                CC="$CC $defines" \
                CXX="$CXX $defines" \
                AR="$AR" \
                RANLIB="$RANLIB" \
                -j"$(nproc)" \
                "${MAKE_ARGS[@]}"
    ) || return 1

    out=$(find_core_output "$SRC/$make_dir" "$so") || return 1
    stage_core "$out"
}

# CMake counterpart of build_libretro_core, through the SDK's toolchain file
# (prospero-cmake). The flags go in CMAKE_C_FLAGS/CMAKE_CXX_FLAGS, which the
# project appends to rather than replaces.
build_cmake_libretro_core() {
    local core="${CORE:?CORE is not set}"
    local cmake_dir="${CMAKE_DIR:-.}"
    local target="${CMAKE_TARGET:-${core}_libretro}"
    local so="${SO:-${core}_libretro.so}"
    local defines out

    fetch_core_source || return 1

    if declare -F core_pre_build >/dev/null; then
        ( cd "$SRC" && core_pre_build ) || return 1
    fi

    defines=$(core_defines)
    "$CMAKE" -S "$SRC/$cmake_dir" -B "$SRC/build-ps5" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_FLAGS="$defines" \
        -DCMAKE_CXX_FLAGS="$defines" \
        "${CMAKE_ARGS[@]}" || return 1

    "$CMAKE" --build "$SRC/build-ps5" --target "$target" -j"$(nproc)" || return 1

    out=$(find_core_output "$SRC/build-ps5" "$so") || return 1
    stage_core "$out"
}
