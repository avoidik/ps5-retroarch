# RetroArch for jailbroken PS5

Build recipes for a RetroArch payload for a jailbroken PS5, with 115 libretro
cores.

The PS5 port of RetroArch itself is **john-tornblom's**, distributed as part of
[ps5-payload-dev/websrv](https://github.com/ps5-payload-dev/websrv). This
repository is that port plus extra cores; all of the porting work is his.

## Systems included

| Core | System |
|---|---|
| `fceumm` | NES / Famicom |
| `nestopia` | NES / Famicom (more accurate, heavier) |
| `snes9x` | SNES |
| `snes9x2010` | SNES (older, lighter fork) |
| `gambatte` | Game Boy / Game Boy Color |
| `mgba` | Game Boy / Game Boy Color / Game Boy Advance |
| `mednafen_gba` | Game Boy Advance |
| `desmume2015` | Nintendo DS |
| `parallel_n64` | Nintendo 64 |
| `genesis_plus_gx` | Mega Drive / Master System / Game Gear |
| `picodrive` | Mega Drive / Sega CD / 32X / Master System / Game Gear |
| `yabause` | Sega Saturn |
| `mednafen_pce_fast` | PC Engine / TurboGrafx-16 / PCE-CD |
| `mednafen_psx` | PlayStation |
| `pcsx_rearmed` | PlayStation (faster) |
| `opera` | 3DO |
| `mednafen_vb` | Virtual Boy |
| `mednafen_wswan` | WonderSwan / WonderSwan Color |
| `mednafen_ngp` | Neo Geo Pocket / Color |
| `stella2023` | Atari 2600 |
| `prosystem` | Atari 7800 |
| `handy` | Atari Lynx |
| `virtualjaguar` | Atari Jaguar |
| `mame2003_plus` | Arcade |
| `mame2010` | Arcade (newer romsets) |
| `fbneo` | Arcade (FinalBurn Neo) |
| `fbalpha2012_cps1` | Arcade - Capcom CPS-1 |
| `fbalpha2012_cps2` | Arcade - Capcom CPS-2 |
| `fbalpha2012_neogeo` | Arcade - Neo Geo |
| `puae` / `puae2021` | Amiga |
| `vice_x64` | Commodore 64 |
| `dosbox_pure` | MS-DOS / PC |
| `prboom` | Doom / Doom II / Final Doom / Freedoom (bring your own WADs) |
| `crocods` | Amstrad - CPC (CrocoDS) |
| `cap32` | Amstrad - CPC/GX4000 (Caprice32) |
| `applewin` | Apple II (AppleWin) |
| `dice` | Arcade (DICE) |
| `fbalpha2012_cps3` | Arcade (FB Alpha 2012 CPS-3) |
| `fbalpha2012` | Arcade (FB Alpha 2012) |
| `mame2000` | Arcade (MAME 2000) |
| `mame2003` | Arcade (MAME 2003) |
| `arduous` | Arduboy (Arduous) |
| `stella2014` | Atari - 2600 (Stella 2014) |
| `stella` | Atari - 2600 (Stella 7.0) |
| `atari800` | Atari - 400/800/600XL/800XL/130XE/5200 (Atari800) |
| `a5200` | Atari - 5200 (a5200) |
| `mednafen_lynx` | Atari - Lynx (Beetle Lynx) |
| `hatari` | Atari - ST / STE / TT / Falcon (Hatari) |
| `tamalibretro` | Bandai - Tamagotchi P1 (TamaLIBretro) |
| `jollycv` | ColecoVision/CreatiVision/My Vision (JollyCV) |
| `vice_x128` | Commodore - C128 (VICE x128) |
| `vice_x64sc` | Commodore - C64 (VICE x64sc, accurate) |
| `vice_xscpu64` | Commodore - C64 SuperCPU (VICE xscpu64) |
| `vice_xcbm5x0` | Commodore - CBM-II 5x0 (VICE xcbm5x0) |
| `vice_xcbm2` | Commodore - CBM-II 6x0/7x0 (VICE xcbm2) |
| `vice_xpet` | Commodore - PET (VICE xpet) |
| `vice_xplus4` | Commodore - PLUS/4 (VICE xplus4) |
| `vice_xvic` | Commodore - VIC-20 (VICE xvic) |
| `dosbox_core` | DOS (DOSBox-core) |
| `dosbox_svn` | DOS (DOSBox-SVN) |
| `bk` | Elektronika - BK-0010/BK-0011(M) |
| `emuscv` | EPOCH/YENO Super Cassette Vision |
| `freechaf` | Fairchild - ChannelF (FreeChaF) |
| `gw` | Handheld Electronic (GW) |
| `squirreljme` | Java ME (SquirrelJME) |
| `dirksimple` | Laserdisc arcade game (DirkSimple) |
| `o2em` | Magnavox - Odyssey2 / Philips Videopac+ (O2EM) |
| `freeintv` | Mattel - Intellivision (FreeIntv) |
| `fmsx` | Microsoft - MSX (fMSX) |
| `bluemsx` | MSX/SVI/ColecoVision/SG-1000 (blueMSX) |
| `mednafen_pce` | NEC - PC Engine / SuperGrafx / CD (Beetle PCE) |
| `mednafen_supergrafx` | NEC - PC Engine SuperGrafx (Beetle SuperGrafx) |
| `quasi88` | NEC - PC-88 series (QUASI88) |
| `np2kai` | NEC - PC-98 (Neko Project II Kai) |
| `nekop2` | NEC - PC-98 (Neko Project II) |
| `mednafen_pcfx` | NEC - PC-FX (Beetle PC-FX) |
| `gearboy` | Nintendo - Game Boy / Color (Gearboy) |
| `sameboy` | Nintendo - Game Boy / Color (SameBoy) |
| `tgbdual` | Nintendo - Game Boy / Color (TGB Dual) |
| `gpsp` | Nintendo - Game Boy Advance (gpSP) |
| `vba_next` | Nintendo - Game Boy Advance (VBA Next) |
| `vbam` | Nintendo - Game Boy Advance (VBA-M) |
| `mesen` | Nintendo - NES / Famicom (Mesen) |
| `quicknes` | Nintendo - NES / Famicom (QuickNES) |
| `pokemini` | Nintendo - Pokemon Mini (PokeMini) |
| `mednafen_supafaust` | Nintendo - SNES / SFC (Beetle Supafaust) |
| `bsnes` | Nintendo - SNES / SFC (bsnes) |
| `bsnes_hd_beta` | Nintendo - SNES / SFC (bsnes-hd beta) |
| `snes9x2002` | Nintendo - SNES / SFC (Snes9x 2002) |
| `snes9x2005_plus` | Nintendo - SNES / SFC (Snes9x 2005 Plus) |
| `snes9x2005` | Nintendo - SNES / SFC (Snes9x 2005) |
| `mesen-s` | Nintendo - SNES / SFC / Game Boy / Color (Mesen-S) |
| `oberon` | Oberon RISC Emulator |
| `mu` | Palm OS (Mu) |
| `same_cdi` | Philips - CDi (SAME CDi) |
| `cdi2015` | Philips CDi (CDi 2015) |
| `retro8` | PICO-8 (Retro8) |
| `clownmdemu` | Sega - MD/CD (ClownMDEmu) |
| `smsplus` | Sega - MS/GG (SMS Plus GX) |
| `genesis_plus_gx_wide` | Sega - MS/GG/MD/CD (Genesis Plus GX Wide) |
| `blastem` | Sega - MS/GG/MD/CD/32X (BlastEm) |
| `gearsystem` | Sega - MS/GG/SG-1000 (Gearsystem) |
| `mednafen_saturn` | Sega - Saturn (Beetle Saturn) |
| `px68k` | Sharp - X68000 (PX68k) |
| `x1` | Sharp X1 (X Millennium) |
| `81` | Sinclair - ZX 81 (EightyOne) |
| `fuse` | Sinclair - ZX Spectrum (Fuse) |
| `geolith` | SNK - Neo Geo AES/MVS/CD (Geolith) |
| `neocd` | SNK - Neo Geo CD (NeoCD) |
| `race` | SNK - Neo Geo Pocket / Color (RACE) |
| `numero` | Texas Instruments TI-83 (Numero) |
| `theodore` | Thomson - MO/TO (Theodore) |
| `uzem` | Uzebox (Uzem) |
| `potator` | Watara - Supervision (Potator) |

## Install

1. Make sure `websrv` is running.
2. A release has two downloads, `RetroArch-PS5-engine.zip` (the frontend, menu
   assets and databases) and `RetroArch-PS5-cores.zip` (the emulator cores).
   Both contain a `RetroArch` folder: unzip them into the same place so they
   merge, then copy the `RetroArch` folder to `homebrew/` on internal storage or
   a USB drive, so you end up with one of:

   ```
   /data/homebrew/RetroArch
   /mnt/usb0/homebrew/RetroArch      (usb0 through usb7)
   /mnt/ext0/homebrew/RetroArch      (ext0, ext1)
   ```

3. Open the Homebrew Launcher on the console and pick **RetroArch**.

BIOS files in`.config/retroarch/system`

## Using it

Load a game with **Load Content**, then browse to your ROM. RetroArch picks the
core automatically for most systems; where two cores can open the same file it
asks which to use.

The menu is RGUI (the plain list-style interface).

- **Open or close the menu while a game is running:** press L3 + R3 (click both
  analog sticks).
- **Confirm / cancel:** cross and circle are swapped to match PlayStation
  convention, so cross confirms.
- **Touchpad as a pointer:** the DualSense touchpad moves the on-screen pointer
  and pressing it clicks. Useful for the Nintendo DS touch screen and for arcade
  games with a trackball or lightgun.

Settings are saved when you exit through **Quit RetroArch** in the menu. If the
console is powered off with RetroArch still running, changes made in that session
are lost.

## Rebuilding

| Script | Builds |
|---|---|
| `build-sdl.sh` | SDL2 with the DualSense touchpad patch - **run before `build.sh`** |
| `build.sh` | the frontend, `retroarch.elf` |
| `build-core.sh <core>` | one core; `--all` for every core, `--list` for what is available |
| `fetch-assets.sh`, `fetch-databases.sh` | menu assets and game databases |

The core recipes live in `cores/`, grouped by how each core is built:

| Path | Holds |
|---|---|
| `cores/typical/table.txt` | 89 cores built from upstream source as is - one row each: a repository, a makefile path, make arguments |
| `cores/patched/<name>.sh` | 19 cores that need more: a source patch, a build assertion, an `.info` fixup, or a non-make build (`mgba`, `applewin`, `arduous`, `dirksimple`, `hatari` and `squirreljme` use CMake) |
| `cores/websrv/<name>.sh` | 7 cores whose scripts come from [ps5-payload-dev/websrv](https://github.com/ps5-payload-dev/websrv/tree/master/homebrew/RetroArch), kept close to the originals so upstream changes are easy to compare; local changes are marked in each script |
| `cores/_common.sh` | shared fetch, cross-compile, verify and stage logic |
| `cores/_matrix.py` | the core list as a build matrix for the release workflow |

A core name may appear in only one of these places. Adding a straightforward
core means adding one row to `cores/typical/table.txt` - `build-core.sh` and the
release workflow both read it, so nothing else changes.

Each core lands in `.config/retroarch/cores` next to its `.info` file. Before a
core is staged - by `_common.sh` for the table and for the patched scripts that
use it, and by the release workflow for every core - it must export the libretro
entry points in its **dynamic** symbol table, import `libkernel_web.sprx` (proof
the Prospero toolchain was used and not the host compiler), not import
`libkernel_sys.sprx` (absent from websrv's process, and a module that wants it
fails to load with nothing shown on screen), and not declare `hw_render`.

You need the [ps5-payload-dev/sdk](https://github.com/ps5-payload-dev/sdk)
toolchain plus the prebuilt sysroot, on Ubuntu 24.04 (the SDK pins clang/lld 18):

```sh
sudo apt-get install -y clang-18 lld-18 llvm-18 llvm-18-dev build-essential cmake pkg-config wget unzip

wget https://github.com/ps5-payload-dev/sdk/releases/latest/download/ps5-payload-sdk.zip
sudo unzip -d /opt ps5-payload-sdk.zip

# prebuilt third-party libs (SDL2, ffmpeg, freetype, zlib, ...); extracts over /
wget https://github.com/ps5-payload-dev/pacbrew-repo/releases/latest/download/ps5-payload-dev.tar.gz
sudo tar xf ps5-payload-dev.tar.gz -C /

# build-sdl.sh installs the patched SDL2 into the SDK sysroot, so it must be writable
sudo chown -R "$USER" /opt/ps5-payload-sdk

export PS5_PAYLOAD_SDK=/opt/ps5-payload-sdk
./build-sdl.sh          # patched SDL, before the frontend
./build.sh              # retroarch.elf
./build-core.sh fceumm  # a core (--all for every core)
./fetch-assets.sh && ./fetch-databases.sh
```

## Licence

RetroArch and the websrv port are **GPLv3**; the full text is in
[LICENSE](LICENSE). The files taken from websrv (`build.sh`, `homebrew.js`) keep
their original copyright and licence headers. `build.sh` has been modified here -
it no longer overwrites an existing `retroarch.cfg` on rebuild.

The cores are **not** all under the same licence:

| Core | Licence |
|---|---|
| `fceumm`, `nestopia`, `gambatte`, `mednafen_gba`, `mednafen_psx`, `mednafen_pce_fast`, `mednafen_vb`, `mednafen_wswan`, `mednafen_ngp`, `pcsx_rearmed`, `desmume2015`, `parallel_n64`, `yabause`, `stella2023`, `prosystem`, `puae`, `puae2021`, `vice_x64`, `dosbox_pure`, `prboom`, `a5200`, `applewin`, `atari800`, `bluemsx`, `cap32`, `dosbox_core`, `dosbox_svn`, `gpsp`, `hatari`, `mednafen_pce`, `mednafen_pcfx`, `mednafen_saturn`, `mednafen_supergrafx`, `numero`, `race`, `smsplus`, `stella2014`, `tamalibretro`, `tgbdual`, `vba_next`, `vbam`, `vice_x128`, `vice_x64sc`, `vice_xcbm2`, `vice_xcbm5x0`, `vice_xpet`, `vice_xplus4`, `vice_xscpu64`, `vice_xvic`, `stella` | GPLv2 |
| `virtualjaguar`, `81`, `arduous`, `blastem`, `bsnes`, `bsnes_hd_beta`, `dice`, `emuscv`, `freechaf`, `fuse`, `gearboy`, `gearsystem`, `mesen`, `mesen-s`, `pokemini`, `retro8`, `theodore` | GPLv3 |
| `mgba`, `squirreljme` | MPL 2.0 |
| `handy`, `dirksimple`, `gw` | Zlib |
| `opera` | LGPL / non-commercial |
| `genesis_plus_gx`, `snes9x`, `snes9x2010`, `fbneo`, `fbalpha2012_cps1`, `fbalpha2012_cps2`, `fbalpha2012_neogeo`, `fbalpha2012`, `fbalpha2012_cps3`, `fmsx`, `genesis_plus_gx_wide`, `snes9x2002`, `snes9x2005`, `snes9x2005_plus` | Non-commercial |
| `mame2003_plus`, `mame2010`, `picodrive`, `mame2000`, `mame2003` | MAME licence (non-commercial) |
| `crocods`, `nekop2`, `np2kai`, `sameboy`, `uzem` | MIT |
| `cdi2015`, `freeintv`, `mednafen_supafaust`, `same_cdi` | GPLv2+ |
| `geolith`, `jollycv` | BSD-3-Clause, MIT |
| `clownmdemu` | AGPLv3 |
| `o2em` | Artistic License |
| `x1` | BSD |
| `quasi88` | BSD 3-Clause and MAME non-commercial |
| `mu` | CC BY-NC 3.0 US (Non-commercial) |
| `px68k` | Custom Non-Commercial |
| `bk` | HPND |
| `oberon` | ISC |
| `quicknes` | LGPLv2.1+ |
| `neocd` | LGPLv3 |
| `potator` | Public Domain |
| `mednafen_lynx` | Zlib / GPLv2 |

No binaries are committed to this repository, but **the release zips do contain
them**, so those terms apply to the releases: the non-commercial cores may not be
redistributed commercially, and MAME's licence has its own conditions. The GPLv2
cores are built from the upstream sources named in `cores/typical/table.txt`,
`cores/patched/` and `cores/websrv/`, which serve as the corresponding source.

Bundled fonts and menu assets carry their own licences, included alongside them
under `.config/retroarch/assets`.
