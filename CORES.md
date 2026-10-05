# Cores

What this payload ships, where each core comes from, and how the set compares
with the official RetroArch distribution.

Snapshot taken **2026-10-05**. Upstream dates and counts change; re-run the checks
described at the end to refresh them.

## At a glance

| | |
|---|---|
| Cores shipped | **33**: 19 typical (`cores/typical/table.txt`), 7 patched (`cores/patched/`), 7 from websrv (`cores/websrv/`) |
| Official Linux x86_64 cores | 244 |
| Missing from the official set | 211 |
| Missing, but impossible here (hardware rendering) | 28 |
| Missing, software-rendered emulators | 140 (roughly 100 once variants of shipped emulators are set aside) |
| Pinned to a release | 1 (`dosbox_pure`) |
| Tracking a branch head | 32 |

## Recipe categories

Every core is defined in exactly one of three places under `cores/`;
`build-core.sh` and the release workflow refuse a name defined twice.

| Category | Location | Cores | What it means |
|---|---|---|---|
| typical | `typical/table.txt` | 19 | Upstream source built as is with the shared flags in `_common.sh`: one row naming a repository, makefile path and make arguments. |
| patched | `patched/<name>.sh` | 7 | Needs a source patch, a build assertion or an `.info` fixup. `parallel_n64` and `picodrive` use `_common.sh` with hooks; the other five fetch and build on their own. |
| websrv | `websrv/<name>.sh` | 7 | Taken from [ps5-payload-dev/websrv](https://github.com/ps5-payload-dev/websrv/tree/master/homebrew/RetroArch) (`build-<name>.sh` there). The only change is the staging path, so upstream changes can be compared directly. `puae2021`'s `key_t` patch is websrv's own. |

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
| `mgba` | GB / GBC / GBA | libretro/mgba | master | 2026-09-17 | typical | MPL 2.0 |
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

## What the recipes have to work around

Every core passes through the same constraints of the payload environment. These
explain most of the per-core scripts:

- **No executable memory.** The payload sandbox refuses `PROT_EXEC` pages, so no
  JIT or dynamic recompiler can run. `dosbox_pure` builds with
  `DISABLE_DYNAREC=1`, `picodrive` with `use_sh2drc=0`, `pcsx_rearmed` with
  `DYNAREC=0`; the first two also assert after the build that no recompiler
  symbols survived. This is the main reason the heavier systems (N64, Saturn,
  PS1 on `mednafen_psx`) will be slow.
- **No GL context.** The frontend renders through SDL2's software renderer, so a
  core whose `.info` declares `hw_render = "true"` is rejected at staging.
  `parallel_n64` is built with `HAVE_OPENGL=0` and no GLideN64/Glide64.
- **BSD-flavoured libc.** Several scripts patch out glibc or Linux assumptions:
  `_POSIX_C_SOURCE` that hides C99 maths (`desmume2015`), `*64` file calls and
  `std::tr1` (`mame2010`), `-lm` (`mame2003_plus`), a `key_t` typedef
  (`puae2021`), and `strtof_l` (`mgba`, via `shims/ps5-locale.h`).
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

Tracking `master` has a cost: two builds a week apart can differ, and a broken
upstream commit breaks the release. Pinning each recipe to a commit hash would
make builds reproducible, at the price of updating the pins by hand.

## Coverage against the official distribution

Reference: the libretro buildbot nightly for Linux x86_64
(`buildbot.libretro.com/nightly/linux/x86_64/latest/.index`), the most complete
official build and the same CPU architecture as the PS5. Each missing core was
classified from its `.info` in
[libretro-core-info](https://github.com/libretro/libretro-core-info).

All 33 cores shipped here appear in the official list. The 211 that do not:

| Group | Count | Can it run here? |
|---|---|---|
| Hardware rendering required | 28 | **No.** No GL context. |
| No `.info` (a CI log, unreleased or retired cores) | 6 | Not real candidates |
| Game and engine ports | 29 | Probably. Most are software-rendered. |
| Media players and utilities | 8 | Low value |
| Software-rendered emulators | 140 | Plausibly. 18 are flagged experimental. |

**Ruled out (hardware rendering):** 3dengine, azahar, boom3, cemu, citra,
citra2018, desmume, dolphin, doukutsu_rs, flycast, kronos, mednafen_psx_hw,
melonds, melondsds, mupen64plus_next, nuance, omicron, openlara, panda3ds, pcee2,
pcsx2, ppsspp, supermodel, swanstation, thepowdertoy, vecx, vircon32,
yabasanshiro. This takes out every modern system (GameCube/Wii, PS2, PSP, 3DS,
Dreamcast) and the GPU-accelerated variants of systems already covered.

**Variants of emulators already shipped** account for about 40 of the 140:
nine more VICE machines (x128, x64sc, PET, Plus/4, VIC-20, CBM-II, SCPU64), about
thirteen bsnes and Snes9x builds, Stella 2014 and current, three more Hatari
builds, three more DOSBox builds, and nine more MAME/FB Alpha versions. Adding
them widens choice rather than coverage.

### Systems with no core at all

These are the real gaps: every core for them is software-rendered and missing.

| System | Candidate cores |
|---|---|
| MSX / MSX2 | `bluemsx`, `fmsx` |
| ZX Spectrum | `fuse` |
| Amstrad CPC | `cap32`, `crocods` |
| Atari ST / STE | `hatari` |
| Atari 8-bit / 5200 | `atari800`, `a5200` |
| NEC PC-98 | `np2kai`, `nekop2` |
| NEC PC-88 | `quasi88` |
| Sharp X68000 | `px68k` |
| Apple II / early Macintosh | `applewin`, `minivmac` |
| ColecoVision | `gearcoleco`, `jollycv` |
| Intellivision | `freeintv` |
| Odyssey² / Videopac | `o2em` |
| Neo Geo CD | `neocd` |
| PC-FX | `mednafen_pcfx` |
| SuperGrafx | `mednafen_supergrafx`, `geargrafx` |
| Pokémon Mini | `pokemini` |
| Fairchild Channel F | `freechaf` |
| Watara Supervision | `potator` |
| Philips CD-i | `same_cdi`, `cdi2015` |
| PICO-8 / TIC-80 fantasy consoles | `retro8`, `tic80` |

### Stronger alternatives to shipped cores

| Instead of / alongside | Candidate | Why |
|---|---|---|
| `fceumm`, `nestopia` | `mesen` | Most accurate NES core |
| `snes9x` | `mesen-s`, `bsnes` | Accuracy; `bsnes` is heavy without a recompiler |
| `gambatte` | `sameboy`, `gearboy` | SameBoy is the accuracy reference |
| `mgba`, `mednafen_gba` | `gpsp`, `vba_next` | Lighter; `gpsp`'s speed comes from a JIT this target cannot use |
| `genesis_plus_gx` | `blastem`, `clownmdemu` | Cycle-accurate Mega Drive |
| `yabause` | `mednafen_saturn` | Far more accurate, but much heavier |
| `mednafen_ngp` | `race` | Lighter Neo Geo Pocket |
| `mame2003_plus`, `mame2010` | `mame2003`, `mame2015` | Other romset generations |

### Game and engine ports

`scummvm` is the most valuable single addition: hundreds of adventure games
from one core. After it, the cheap ones are `prboom` (Doom), `tyrquake` (Quake),
`ecwolf` (Wolfenstein 3D), `nxengine` (Cave Story, which also bundles its data),
`easyrpg` (RPG Maker 2000/2003), `cannonball` (OutRun), `mrboom` and `tic80`.
The full list: 2048, anarch, cannonball, chailove, craft, dinothawr, easyrpg,
ecwolf, gong, jumpnbump, lowresnx, lutro, mrboom, nxengine, prboom,
reminiscence, scummvm, superbroswar, tic80, tyrquake, uw8, vemulator,
vitaquake2 (and its rogue, xatrix and zaero builds), vitaquake3, wasm4, xrick.

## Recommendations

1. **Fill the system gaps first.** One core per uncovered system adds more than
   any number of variants: `bluemsx`, `fuse`, `cap32`, `hatari`, `atari800`,
   `np2kai`, `px68k`, `gearcoleco`, `freeintv`, `o2em`, `neocd`, `pokemini`.
   Most are small C/C++ cores with a plain libretro makefile, so many should
   fit as a single row in `cores/typical/table.txt`.
2. **Add `scummvm`**, then the light game ports (`prboom`, `tyrquake`,
   `nxengine`, `ecwolf`, `easyrpg`).
3. **Add accuracy alternatives selectively** (`mesen`, `sameboy`, `blastem`),
   watching CPU cost. Without a recompiler there is no headroom for the heaviest
   accuracy cores.
4. **Expect porting work, not just table rows.** None of the candidates has been
   built for this target. Typical blockers are the ones listed above: a JIT
   that must be switched off, glibc-only calls, `-lm`/`-lrt` (CI provides empty
   stub archives for these; a local SDK does not), and cores that quietly want
   GL.
5. **Adding a core needs no workflow change.** The release workflow's `plan`
   job runs `cores/_matrix.py`, which builds the matrix and the expected core
   count from `cores/typical/table.txt`, `cores/patched/` and `cores/websrv/`.

## Refreshing this document

- Shipped list: `./build-core.sh --list`.
- Official list: `https://buildbot.libretro.com/nightly/linux/x86_64/latest/.index`,
  one `<core>_libretro.so.zip` per line.
- Rendering requirements and categories: `hw_render` and `categories` in each
  `<core>_libretro.info` from libretro/libretro-core-info.
- Upstream state: `gh api repos/<owner>/<repo>/commits/<ref>` and
  `gh api repos/<owner>/<repo>/releases/latest` for each source above.
