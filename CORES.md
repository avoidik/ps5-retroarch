# Cores

What this payload ships, where each core comes from, and how the set compares
with the official RetroArch distribution.

Snapshot taken **2026-10-05**. Upstream dates and counts change; re-run the checks
described at the end to refresh them.

## At a glance

| Item | Value |
|---|---|
| Cores shipped | **115**: 87 typical (`cores/typical/table.txt`), 21 patched (`cores/patched/`), 7 from websrv (`cores/websrv/`) |
| Added on 2026-10-05 | 81 software-rendered emulators, not yet built in CI at the time of writing (see [Emulators added on 2026-10-05](#emulators-added-on-2026-10-05)) |
| Official Linux x86_64 cores | 244, of which all 115 shipped here are part |
| Missing from the official set | 129 - see [Coverage](#coverage-against-the-official-distribution) |
| Pinned | 3: `dosbox_pure` and `stella` to a release, `quasi88` to a commit (upstream's latest does not compile here) |
| Tracking a branch head | 112 |

## Recipe categories

Every core is defined in exactly one of three places under `cores/`;
`build-core.sh` and the release workflow refuse a name defined twice.

| Category | Location | Cores | What it means |
|---|---|---|---|
| typical | `typical/table.txt` | 87 | Upstream source built as is with the shared flags in `_common.sh`: one row naming a repository, makefile path and make arguments. |
| patched | `patched/<name>.sh` | 21 | Needs a source patch, a build assertion, an `.info` fixup or a non-make build. `parallel_n64`, `picodrive`, `prboom`, `mame2003`, `bsnes_hd_beta`, `same_cdi`, `mednafen_supafaust`, `cdi2015` and `dosbox_core` use `_common.sh`'s make build with hooks (`core_pre_build` patches the makefile or a header for the last seven; `cdi2015` also puts the C++ compiler back in `CC`); `bsnes` and `bsnes_hd_beta` pass the toolchain through nall's own `compiler` variable; `mgba`, `applewin`, `arduous`, `dirksimple`, `hatari` and `squirreljme` use `_common.sh`'s CMake build (`build_cmake_libretro_core`); the other five fetch and build on their own. |
| websrv | `websrv/<name>.sh` | 7 | Taken from [ps5-payload-dev/websrv](https://github.com/ps5-payload-dev/websrv/tree/master/homebrew/RetroArch) (`build-<name>.sh` there), changed as little as possible so upstream changes can be compared directly: the staging path everywhere, plus the compiler flags in `snes9x2010` (see below). `puae2021`'s `key_t` patch is websrv's own. |

The websrv and standalone patched scripts do not use `_common.sh`, so they skip
its local loadability check (the release workflow still checks every core) and
build with plain `make` rather than the shared flags.

Seven scripts that were never in websrv - `desmume2015`, `gambatte`,
`mame2003_plus`, `mame2010`, `mednafen_psx`, `pcsx_rearmed`, `puae` - were
written for [tsuramatsu1/retroarch](https://github.com/tsuramatsu1/retroarch),
which this repository forks, using a websrv script as the template, and carry
its copyright header. The four that patch source are now in `patched/`;
`gambatte`, `mednafen_psx` and `puae` only ran `make`, so they became rows in
`typical/table.txt`.

## Cores in use

"Recipe" is the category folder under `cores/` (see
[Recipe categories](#recipe-categories)). "Source" is the repository the recipe
fetches. Every core except `dosbox_pure` and `puae2021` builds from the head of
`master`, so a rebuild picks up whatever upstream has merged since. "Last upstream commit" is the head of that ref on the
snapshot date.

### Nintendo

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `fceumm` | NES / Famicom | libretro/libretro-fceumm | master | 2026-09-26 | websrv | GPLv2 |
| `nestopia` | NES / Famicom (more accurate) | libretro/nestopia | master | 2026-10-02 | typical | GPLv2 |
| `snes9x` | SNES | libretro/snes9x | master | 2026-09-19 | typical | Non-commercial |
| `snes9x2010` | SNES (lighter fork) | libretro/snes9x2010 | master | 2026-09-21 | websrv | Non-commercial |
| `gambatte` | Game Boy / Color | libretro/gambatte-libretro | master | 2026-08-21 | typical | GPLv2 |
| `mgba` | GB / GBC / GBA | libretro/mgba | master | 2026-09-17 | patched | MPL 2.0 |
| `mednafen_gba` | Game Boy Advance | libretro/beetle-gba-libretro | master | 2026-09-03 | websrv | GPLv2 |
| `desmume2015` | Nintendo DS | libretro/desmume2015 | master | 2026-08-23 | patched | GPLv2 |
| `parallel_n64` | Nintendo 64 | libretro/parallel-n64 | master | 2026-10-05 | patched | GPLv2 |
| `mednafen_vb` | Virtual Boy | libretro/beetle-vb-libretro | master | 2026-08-23 | typical | GPLv2 |

### Sega

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `genesis_plus_gx` | Mega Drive / SMS / Game Gear / Sega CD | libretro/Genesis-Plus-GX | master | 2026-10-02 | websrv | Non-commercial |
| `picodrive` | Mega Drive / Sega CD / 32X / SMS / GG | libretro/picodrive | master | 2026-09-26 | patched | MAME (non-commercial) |
| `yabause` | Saturn | libretro/yabause | master | 2026-05-30 | typical | GPLv2 |

### Sony, NEC, 3DO and handhelds

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `mednafen_psx` | PlayStation | libretro/beetle-psx-libretro | master | 2026-10-05 | typical | GPLv2 |
| `pcsx_rearmed` | PlayStation (faster) | libretro/pcsx_rearmed | master | 2026-10-01 | patched | GPLv2 |
| `mednafen_pce_fast` | PC Engine / TG-16 / PCE-CD | libretro/beetle-pce-fast-libretro | master | 2026-10-02 | typical | GPLv2 |
| `opera` | 3DO | libretro/opera-libretro | master | 2026-10-03 | typical | LGPL / non-commercial |
| `mednafen_wswan` | WonderSwan / Color | libretro/beetle-wswan-libretro | master | 2026-07-31 | typical | GPLv2 |
| `mednafen_ngp` | Neo Geo Pocket / Color | libretro/beetle-ngp-libretro | master | 2026-06-14 | typical | GPLv2 |

### Atari

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `stella2023` | Atari 2600 | libretro/stella2023 | master | 2026-08-29 | typical | GPLv2 |
| `prosystem` | Atari 7800 | libretro/prosystem-libretro | master | 2026-08-22 | typical | GPLv2 |
| `handy` | Atari Lynx | libretro/libretro-handy | master | 2026-04-20 | typical | Zlib |
| `virtualjaguar` | Atari Jaguar | libretro/virtualjaguar-libretro | master (= v3.6.1) | 2026-09-05 | typical | GPLv3 |

### Arcade

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `mame2003_plus` | Arcade (0.78 romsets) | libretro/mame2003-plus-libretro | master | 2026-10-01 | patched | MAME (non-commercial) |
| `mame2010` | Arcade (0.139 romsets) | libretro/mame2010-libretro | master | 2026-09-02 | patched | MAME (non-commercial) |
| `fbneo` | Arcade (FinalBurn Neo) | libretro/FBNeo | master | 2026-10-02 | websrv | Non-commercial |
| `fbalpha2012_cps1` | Capcom CPS-1 | libretro/fbalpha2012_cps1 | master | 2026-07-28 | typical | Non-commercial |
| `fbalpha2012_cps2` | Capcom CPS-2 | libretro/fbalpha2012_cps2 | master | 2026-07-28 | typical | Non-commercial |
| `fbalpha2012_neogeo` | Neo Geo | libretro/fbalpha2012_neogeo | master | 2026-07-28 | typical | Non-commercial |

### Computers

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `puae` | Amiga | libretro/libretro-uae | master | 2026-09-06 | typical | GPLv2 |
| `puae2021` | Amiga (older fork) | libretro/libretro-uae | 2.6.1 branch | 2026-09-06 | websrv | GPLv2 |
| `vice` (`vice_x64`) | Commodore 64 | libretro/vice-libretro | master | 2026-10-03 | websrv | GPLv2 |
| `dosbox_pure` | MS-DOS / PC | codeberg.org/schelling/dosbox-pure | **1.0-preview6** | release 2026-07-14 | patched | GPLv2 |

### Game engines

| Core | System | Source | Ref | Last upstream commit | Recipe | Licence |
|---|---|---|---|---|---|---|
| `prboom` | Doom / Doom II / Final Doom / Freedoom | libretro/libretro-prboom | master | 2026-10-05 | patched | GPLv2 |

`prboom` needs the game's own WAD files, which are not distributed here. Load an
IWAD (`doom.wad`, `doom2.wad`, `tnt.wad`, `plutonia.wad`, `freedoom1.wad`,
`freedoom2.wad`) or a PWAD add-on placed next to one; the engine's `prboom.wad`
is compiled into the core, despite the older core-info note asking for it.

### Emulators added on 2026-10-05

Generated from libretro-super's `recipes/linux/cores-linux-x64-generic`: every
software-rendered, non-experimental emulator in the official x86_64 build with a
make or CMake recipe there, except the full MAME/HBMAME builds and `rustynes`
(Rust; no Rust toolchain targets the PS5). `stella` is pinned to the 7.0
release: its `master` needs a newer C++ compiler than the SDK's clang 18. None had been built for this target
when they were added, so the first CI runs decide which need more work.

| Core | System | Source | Branch | Recipe | Licence |
|---|---|---|---|---|---|
| `crocods` | Amstrad - CPC (CrocoDS) | libretro/libretro-crocods | master | typical | MIT |
| `cap32` | Amstrad - CPC/GX4000 (Caprice32) | libretro/libretro-cap32 | master | typical | GPLv2 |
| `applewin` | Apple II (AppleWin) | audetto/AppleWin | master | patched | GPLv2 |
| `dice` | Arcade (DICE) | mittonk/dice-libretro | main | typical | GPLv3 |
| `fbalpha2012_cps3` | Arcade (FB Alpha 2012 CPS-3) | libretro/fbalpha2012_cps3 | master | typical | Non-commercial |
| `fbalpha2012` | Arcade (FB Alpha 2012) | libretro/fbalpha2012 | master | typical | Non-commercial |
| `mame2000` | Arcade (MAME 2000) | libretro/mame2000-libretro | master | typical | MAME |
| `mame2003` | Arcade (MAME 2003) | libretro/mame2003-libretro | master | patched | MAME |
| `arduous` | Arduboy (Arduous) | libretro/arduous | main | patched | GPLv3 |
| `stella2014` | Atari - 2600 (Stella 2014) | libretro/stella2014-libretro | master | typical | GPLv2 |
| `stella` | Atari - 2600 (Stella) | stella-emu/stella | **7.0** (d55b1aec0d, pinned) | typical | GPLv2 |
| `atari800` | Atari - 400/800/600XL/800XL/130XE/5200 (Atari800) | libretro/libretro-atari800 | master | typical | GPLv2 |
| `a5200` | Atari - 5200 (a5200) | libretro/a5200 | master | typical | GPLv2 |
| `mednafen_lynx` | Atari - Lynx (Beetle Lynx) | libretro/beetle-lynx-libretro | master | typical | Zlib / GPLv2 |
| `hatari` | Atari - ST / STE / TT / Falcon (Hatari) | libretro/hatari | main | patched | GPLv2 |
| `tamalibretro` | Bandai - Tamagotchi P1 (TamaLIBretro) | celerizer/tamalibretro | master | typical | GPL-2.0 |
| `jollycv` | ColecoVision/CreatiVision/My Vision (JollyCV) | libretro/jollycv | master | typical | BSD-3-Clause, MIT |
| `vice_x128` | Commodore - C128 (VICE x128) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_x64sc` | Commodore - C64 (VICE x64sc, accurate) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_xscpu64` | Commodore - C64 SuperCPU (VICE xscpu64) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_xcbm5x0` | Commodore - CBM-II 5x0 (VICE xcbm5x0) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_xcbm2` | Commodore - CBM-II 6x0/7x0 (VICE xcbm2) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_xpet` | Commodore - PET (VICE xpet) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_xplus4` | Commodore - PLUS/4 (VICE xplus4) | libretro/vice-libretro | master | typical | GPLv2 |
| `vice_xvic` | Commodore - VIC-20 (VICE xvic) | libretro/vice-libretro | master | typical | GPLv2 |
| `dosbox_core` | DOS (DOSBox-core) | libretro/dosbox-core | libretro | patched | GPLv2 |
| `dosbox_svn` | DOS (DOSBox-SVN) | libretro/dosbox-svn | libretro | typical | GPLv2 |
| `bk` | Elektronika - BK-0010/BK-0011(M) | libretro/bk-emulator | master | typical | HPND |
| `emuscv` | EPOCH/YENO Super Cassette Vision | gitlab.com/MaaaX-EmuSCV/libretro-emuscv | master | typical | GPLv3 |
| `freechaf` | Fairchild - ChannelF (FreeChaF) | libretro/FreeChaF | master | typical | GPLv3 |
| `gw` | Handheld Electronic (GW) | libretro/gw-libretro | master | typical | zlib |
| `squirreljme` | Java ME (SquirrelJME) | XerTheSquirrel/SquirrelJME | trunk | patched | MPL-2.0 |
| `dirksimple` | Laserdisc arcade game (DirkSimple) | icculus/DirkSimple | main | patched | zlib |
| `o2em` | Magnavox - Odyssey2 / Philips Videopac+ (O2EM) | libretro/libretro-o2em | master | typical | Artistic License |
| `freeintv` | Mattel - Intellivision (FreeIntv) | libretro/FreeIntv | master | typical | GPLv2+ |
| `fmsx` | Microsoft - MSX (fMSX) | libretro/fmsx-libretro | master | typical | Non-commercial |
| `bluemsx` | MSX/SVI/ColecoVision/SG-1000 (blueMSX) | libretro/blueMSX-libretro | master | typical | GPLv2 |
| `mednafen_pce` | NEC - PC Engine / SuperGrafx / CD (Beetle PCE) | libretro/beetle-pce-libretro | master | typical | GPLv2 |
| `mednafen_supergrafx` | NEC - PC Engine SuperGrafx (Beetle SuperGrafx) | libretro/beetle-supergrafx-libretro | master | typical | GPLv2 |
| `quasi88` | NEC - PC-88 series (QUASI88) | libretro/quasi88-libretro | **d43ef693eb** (pinned) | typical | BSD 3-Clause and MAME non-commercial |
| `np2kai` | NEC - PC-98 (Neko Project II Kai) | libretro/NP2kai | master | typical | MIT |
| `nekop2` | NEC - PC-98 (Neko Project II) | libretro/libretro-meowPC98 | master | typical | MIT |
| `mednafen_pcfx` | NEC - PC-FX (Beetle PC-FX) | libretro/beetle-pcfx-libretro | master | typical | GPLv2 |
| `gearboy` | Nintendo - Game Boy / Color (Gearboy) | drhelius/Gearboy | master | typical | GPLv3 |
| `sameboy` | Nintendo - Game Boy / Color (SameBoy) | libretro/SameBoy | buildbot | typical | MIT |
| `tgbdual` | Nintendo - Game Boy / Color (TGB Dual) | libretro/tgbdual-libretro | master | typical | GPLv2 |
| `gpsp` | Nintendo - Game Boy Advance (gpSP) | libretro/gpsp | master | typical | GPLv2 |
| `vba_next` | Nintendo - Game Boy Advance (VBA Next) | libretro/vba-next | master | typical | GPLv2 |
| `vbam` | Nintendo - Game Boy Advance (VBA-M) | libretro/vbam-libretro | master | typical | GPLv2 |
| `mesen` | Nintendo - NES / Famicom (Mesen) | libretro/Mesen | master | typical | GPLv3 |
| `quicknes` | Nintendo - NES / Famicom (QuickNES) | libretro/QuickNES_Core | master | typical | LGPLv2.1+ |
| `pokemini` | Nintendo - Pokemon Mini (PokeMini) | libretro/PokeMini | master | typical | GPLv3 |
| `mednafen_supafaust` | Nintendo - SNES / SFC (Beetle Supafaust) | libretro/supafaust | master | patched | GPLv2+ |
| `bsnes` | Nintendo - SNES / SFC (bsnes) | libretro/bsnes-libretro | master | patched | GPLv3 |
| `bsnes_hd_beta` | Nintendo - SNES / SFC (bsnes-hd beta) | DerKoun/bsnes-hd | master | patched | GPLv3 |
| `snes9x2002` | Nintendo - SNES / SFC (Snes9x 2002) | libretro/snes9x2002 | master | typical | Non-commercial |
| `snes9x2005_plus` | Nintendo - SNES / SFC (Snes9x 2005 Plus) | libretro/snes9x2005 | master | typical | Non-commercial |
| `snes9x2005` | Nintendo - SNES / SFC (Snes9x 2005) | libretro/snes9x2005 | master | typical | Non-commercial |
| `mesen-s` | Nintendo - SNES / SFC / Game Boy / Color (Mesen-S) | libretro/Mesen-S | master | typical | GPLv3 |
| `oberon` | Oberon RISC Emulator | libretro/oberon-risc-emu | master | typical | ISC |
| `mu` | Palm OS (Mu) | libretro/Mu | master | typical | CC BY-NC 3.0 US (Non-commercial) |
| `same_cdi` | Philips - CDi (SAME CDi) | libretro/same_cdi | master | patched | GPLv2+ |
| `cdi2015` | Philips CDi (CDi 2015) | libretro/mame2015-libretro | master | patched | GPLv2+ |
| `retro8` | PICO-8 (Retro8) | libretro/retro8 | master | typical | GPLv3 |
| `clownmdemu` | Sega - MD/CD (ClownMDEmu) | Clownacy/clownmdemu-libretro | master | typical | AGPLv3 |
| `smsplus` | Sega - MS/GG (SMS Plus GX) | libretro/smsplus-gx | master | typical | GPLv2 |
| `genesis_plus_gx_wide` | Sega - MS/GG/MD/CD (Genesis Plus GX Wide) | libretro/Genesis-Plus-GX-Wide | main | typical | Non-commercial |
| `blastem` | Sega - MS/GG/MD/CD/32X (BlastEm) | libretro/blastem | libretro | typical | GPLv3 |
| `gearsystem` | Sega - MS/GG/SG-1000 (Gearsystem) | drhelius/Gearsystem | master | typical | GPLv3 |
| `mednafen_saturn` | Sega - Saturn (Beetle Saturn) | libretro/beetle-saturn-libretro | master | typical | GPLv2 |
| `px68k` | Sharp - X68000 (PX68k) | libretro/px68k-libretro | master | typical | Custom Non-Commercial |
| `x1` | Sharp X1 (X Millennium) | libretro/xmil-libretro | master | typical | BSD |
| `81` | Sinclair - ZX 81 (EightyOne) | libretro/81-libretro | master | typical | GPLv3 |
| `fuse` | Sinclair - ZX Spectrum (Fuse) | libretro/fuse-libretro | master | typical | GPLv3 |
| `geolith` | SNK - Neo Geo AES/MVS/CD (Geolith) | libretro/geolith-libretro | master | typical | BSD-3-Clause, MIT |
| `neocd` | SNK - Neo Geo CD (NeoCD) | libretro/neocd_libretro | master | typical | LGPLv3 |
| `race` | SNK - Neo Geo Pocket / Color (RACE) | libretro/RACE | master | typical | GPLv2 |
| `numero` | Texas Instruments TI-83 (Numero) | nbarkhina/numero | master | typical | GPLv2 |
| `theodore` | Thomson - MO/TO (Theodore) | Zlika/theodore | master | typical | GPLv3 |
| `uzem` | Uzebox (Uzem) | libretro/libretro-uzem | master | typical | MIT |
| `potator` | Watara - Supervision (Potator) | libretro/potator | master | typical | Public Domain |

## What the recipes have to work around

Every core passes through the same constraints of the payload environment. These
explain most of the per-core scripts:

- **No executable memory.** The payload sandbox refuses `PROT_EXEC` pages, so no
  JIT or dynamic recompiler can run. `dosbox_pure` builds with
  `DISABLE_DYNAREC=1`, `picodrive` with `use_sh2drc=0`, `pcsx_rearmed` with
  `DYNAREC=0`; the first two also assert after the build that no recompiler
  symbols survived. Among the added cores, `dosbox_svn` and `dosbox_core`
  build with `WITH_DYNAREC=`, `gpsp` with `HAVE_DYNAREC=0` and `blastem`
  with `NEW_CORE=1` (its generated 68K/Z80 cores instead of the x86 JIT).
  A recompiler that is compiled in but never switched off would still build
  and pass every check here, then fail on the console - that can only be
  caught by testing there. This is the main reason the heavier systems (N64, Saturn,
  PS1 on `mednafen_psx`) will be slow.
- **No GL context.** The frontend renders through SDL2's software renderer, so a
  core whose `.info` declares `hw_render = "true"` is rejected at staging.
  `parallel_n64` is built with `HAVE_OPENGL=0` and no GLideN64/Glide64.
- **BSD-flavoured libc.** Several scripts patch out glibc or Linux assumptions:
  `_POSIX_C_SOURCE` that hides C99 maths (`desmume2015`) or `snprintf`,
  `strdup` and `madvise` (`prboom`, whose makefile counts on glibc's
  `_DEFAULT_SOURCE` to undo it), `*64` file calls and
  `std::tr1` (`mame2010`), `-lm` (`mame2003_plus`), a `key_t` typedef
  (`puae2021`), and `strtof_l` (`mgba`, via `shims/ps5-locale.h`).
- **The toolchain identifies as FreeBSD** (`__FreeBSD__` = 9). Since
  libretro-common gained thread naming, its `rthreads.c` calls
  `pthread_set_name_np()` on FreeBSD without including `<pthread_np.h>`.
  `shims/ps5-pthread-np.h` supplies just that prototype (the function itself is
  exported by `libkernel_web.sprx`). `_common.sh` force-includes it for every
  core it builds; `pcsx_rearmed` and `snes9x2010` add it themselves.
  `_common.sh` predefines `CLOCK_REALTIME`, `CLOCK_MONOTONIC`,
  `CLOCK_THREAD_CPUTIME_ID` and `CLOCK_PROCESS_CPUTIME_ID` with the header's
  values: `time.h` defines all clock ids in one block that strict POSIX levels
  hide, and predefining any of them hides the rest.
  `snes9x2010` also takes `_common.sh`'s `CLOCK_REALTIME`/`CLOCK_MONOTONIC`
  defines, because its `rthreads.c` pins `_POSIX_C_SOURCE 199309`, which hides
  them. That makes it the one websrv script with a compiler-flag change.
  The shim declares only the function and pulls in nothing but
  `<sys/_pthreadtypes.h>`: an earlier version included `<pthread.h>`, which made
  every CMake `check_function_exists` probe fail and left `mgba` defining its own
  `localtime_r`.
- **Glibc-only headers and clang 18's stricter defaults.** `<malloc.h>` is an
  `#error` on this libc, so `_common.sh` puts `shims/include/` (a `malloc.h`
  that includes `<stdlib.h>`) first on the include path (`81`). It also keeps
  incompatible function-pointer types a warning, as gcc does (`bluemsx`'s ROM
  mappers). `blastem` force-includes `<sys/socket.h>` and `<sys/endian.h>`,
  which glibc pulls in implicitly. `mame2003` gets `mame2003_plus`'s three
  makefile fixes. `shims/include/` also has an `endian.h` with glibc's
  `__BYTE_ORDER` names (`mesen`) and an empty `sys/io.h` (`emuscv` includes the
  x86 port-I/O header without using it).
- **Clang 18 / libc++ 18 strictness.** `_common.sh` also passes `-Wno-register`
  (C++17 dropped `register`; `81`). `cdi2015` drops MAME 2015's
  `malloc`/`realloc` macros, which break libc++'s own headers, and builds with
  `SDLMAME_NO64BITIO` and `NO_AFFINITY_NP` (glibc's `stat64`/`readdir64` and
  `cpu_set_t`, as in `mame2010`), links libc++ instead of the makefile's
  `-lstdc++`, compiles MAME 2015's
  third-party libraries with the PS5 toolchain instead of the host `gcc` its
  makefile defaults `REALCC` to (through `shims/bin/prospero-cc-by-lang`, which
  picks `prospero-clang` or `prospero-clang++` per command because some of
  those "C" files are built with `-x c++`), and
  `mednafen_supafaust` turns off its glibc-only CPU-affinity code.
- **Bundled dependencies built with autoconf** need to be told they are
  cross-compiling: `dosbox_core` and `dosbox_svn` pass
  `TARGET_TRIPLET=x86_64-unknown-freebsd` (their makefiles hand it to
  `configure --host`), and the CI runners install autoconf, automake, libtool
  and libtool-bin (the `libtool` program itself) for the dependencies that run
  `autogen.sh`, plus ninja-build for those configured with CMake's Ninja
  generator. `dosbox_core` builds its own SDL 1.2 (`BUNDLED_SDL=1`, as
  `dosbox_svn` does), turns off ALSA MIDI (`WITH_ALSA_MIDI=0`; its makefile
  checks the build machine's OS), builds all its dependencies in a first
  `make deps` run (`MAKE_FIRST` in `_common.sh`: its makefile reads
  pkg-config before they exist), and drops FLAC's command-line and test
  programs before configuring: FLAC 1.3.4 has no `--disable-programs`, and
  `flac` needs `wcswidth()`, which this libc lacks.
- **The SDK environment exports `DESTDIR`** (its sysroot) for its own library
  builds. `_common.sh` unsets it, or a core that `make install`s its bundled
  dependencies into its own tree (`dosbox_core`) has them re-rooted into the
  sysroot.
- **No physical CD-ROM.** Built with `HAVE_CDROM=0`; disc games load from images.
- **Loadability.** Every staged `.so` must export the libretro entry points,
  import `libkernel_web.sprx` and not import `libkernel_sys.sprx`. See
  `verify_libretro_so` in `cores/_common.sh`.

## Update check

Checked each recipe's upstream for newer releases on 2026-10-05.

- **`dosbox_pure` changed.** Upstream moved from GitHub to Codeberg on
  2026-10-03, and the GitHub repository now holds only a "project moved" README.
  The recipe was fetching that README. It now builds the latest release,
  **1.0-preview6**, from Codeberg, and has been built and verified locally.
  Codeberg's `main` is about two months ahead of that release (Unicode paths,
  2448-byte-sector ISOs, a Tandy sound freeze fix) if the release is ever too old.
- **Most libretro cores publish no releases.** Their `master` is the release
  line, so building from it is already the latest.
- **Some repositories do publish releases, but they are long stale.**
  `fbalpha2012_*` v1.4.1 (2017, 131 commits behind `master`), `fbneo`
  v1.0.0.02 (2021, 9,127 behind), `mame2003_plus` "Current" (2022, 1,366
  behind). Pinning to any of them would be a large downgrade.
- **`virtualjaguar`'s release v3.6.1 is the same commit as `master`.**
- **`puae2021` follows the `2.6.1` branch on purpose.** It is maintained (last
  commit 2026-09-06) and is the only version branch.
- **No other upstream has moved or been archived.** The latest commit on every
  other core is ordinary maintenance.

The 81 cores added afterwards follow the branch libretro-super's recipe names
for them (`master` for most; `main`, `libretro`, `buildbot` or `trunk` for
twelve) and were not checked for releases individually.

Tracking `master` has a cost: two builds a week apart can differ, and a broken
upstream commit breaks the release. Pinning each recipe to a commit hash would
make builds reproducible, at the price of updating the pins by hand.

## Coverage against the official distribution

Reference: the libretro buildbot nightly for Linux x86_64
(`buildbot.libretro.com/nightly/linux/x86_64/latest/.index`), the most complete
official build and the same CPU architecture as the PS5. Each missing core was
classified from its `.info` in
[libretro-core-info](https://github.com/libretro/libretro-core-info).

All 115 cores shipped here appear in the official list. The 129 that do not:

| Group | Count | Status |
|---|---|---|
| Hardware rendering required | 28 | **Cannot run here** - no GL context |
| No `.info` (a CI log, unreleased or retired cores) | 6 | Not real candidates |
| Game and engine ports | 28 | Left out by choice (emulators only) |
| Media players, streaming, utilities | 6 | Left out by choice |
| Emulators without a libretro-super recipe | 44 | Possible; each needs its repository and build researched by hand |
| Experimental emulators | 12 | Left out by choice |
| Full MAME / HBMAME (`mame`, `hbmame`, `mame2015`, `mame2016`) | 4 | Left out: hours to compile, very large cores |
| `rustynes` | 1 | Needs a Rust toolchain for the PS5 |

**Ruled out (hardware rendering):** 3dengine, azahar, boom3, cemu, citra,
citra2018, desmume, dolphin, doukutsu_rs, flycast, kronos, mednafen_psx_hw,
melonds, melondsds, mupen64plus_next, nuance, omicron, openlara, panda3ds, pcee2,
pcsx2, ppsspp, supermodel, swanstation, thepowdertoy, vecx, vircon32,
yabasanshiro. This takes out every modern system (GameCube/Wii, PS2, PSP, 3DS,
Dreamcast) and the GPU-accelerated variants of systems already covered.

**Emulators without a recipe (44).** Most are variants of systems already
covered (seven more bsnes builds, `DoubleCherryGB`, `irogb`, `hatari2014`,
`hatarib`, `fsuae`, `amiberry`, `dosbox`, `mame2003_midway`, `mesen2`,
`noods`, `geargrafx`, `gearlynx`, `holani`, `tia`). The ones that would add a
system: `gearcoleco` (ColecoVision ADAM), `minivmac` (68k Macintosh),
`virtualxt` (IBM PC/XT), `ep128emu_core` (Enterprise 128), `m2000` (Philips
P2000T), `sameduck` (Mega Duck), `pokketstation` (PocketStation), `pd777`
(Epoch Cassette Vision), `amiarcadia` (Arcadia 2001), `jaxe` (CHIP-8),
`mojozork` (Z-machine), and several electronic-dictionary and handheld
emulators (`bbkemu`, `gam4980`, `wqxemu`, `nicaiemu`, `dingooemu`,
`spmp8000emu`, `native32emu`, `mcsoftserve`, `vaporspec`, `skyemu`).

**Game and engine ports (28):** 2048, anarch, cannonball, chailove, craft,
dinothawr, easyrpg, ecwolf, gong, jumpnbump, lowresnx, lutro, mrboom, nxengine,
reminiscence, scummvm, superbroswar, tic80, tyrquake, uw8, vemulator, vitaquake2
(and its rogue, xatrix and zaero builds), vitaquake3, wasm4, xrick. `prboom`
(Doom) is the one game engine shipped.

## Recommendations

1. **Get the 81 added cores through CI.** The release is blocked until every
   core builds, by choice, so expect several rounds: the usual blockers are a
   JIT that must be switched off, glibc-only calls or feature macros, missing
   libraries in the sysroot (`applewin` needs yaml and minizip), output in an
   unexpected place, and cores that quietly want GL.
2. **Test the added cores on the console.** CI proves a core loads; it cannot
   prove a recompiler is off or that the core is fast enough without one.
3. **Then the emulators without a recipe** that add a system (`minivmac`,
   `virtualxt`, `gearcoleco`, `ep128emu_core`, ...).
4. **Game ports, if wanted:** `scummvm` first (hundreds of adventure games), then
   `tyrquake`, `nxengine`, `ecwolf`, `easyrpg`.
5. **Adding a core needs no workflow change.** The release workflow's `plan`
   job runs `cores/_matrix.py`, which builds the matrix and the expected core
   count from `cores/typical/table.txt`, `cores/patched/` and `cores/websrv/`.

## Refreshing this document

- Shipped list: `./build-core.sh --list`.
- Build recipes for candidate cores: libretro-super's
  `recipes/linux/cores-linux-x64-generic` (name, repository, branch, build type,
  makefile, directory, arguments).
- Official list: `https://buildbot.libretro.com/nightly/linux/x86_64/latest/.index`,
  one `<core>_libretro.so.zip` per line.
- Rendering requirements and categories: `hw_render` and `categories` in each
  `<core>_libretro.info` from libretro/libretro-core-info.
- Upstream state: `gh api repos/<owner>/<repo>/commits/<ref>` and
  `gh api repos/<owner>/<repo>/releases/latest` for each source above.
