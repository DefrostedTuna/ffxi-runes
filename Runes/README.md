# Runes

<p align="center">
  <a href="https://github.com/DefrostedTuna/ffxi-runes/releases">
    <img src="https://img.shields.io/github/v/release/DefrostedTuna/ffxi-runes?label=Stable&sort=semver&logo=github&style=flat-square">
  </a>
</p>

Runes is a [Windower 4](https://www.windower.net/) addon to help automate the management of Rune Enhancement effects for the Rune Fencer job. With Runes, there's no need to worry about buffs dropping and having to flip through macro pages to reapply the same (or entirely different) sets. Simply set the runes that you wish to maintain and let the addon do the rest. When the player character is in combat, or is idle, the addon will read this configuration and automatically reapply the desired runes as needed.

## Prerequisites

Runes requires the use of external support libraries in order to function properly. Prior to installing Runes, make sure to also install my [Windower 4 Support Libraries](https://github.com/DefrostedTuna/ffxi-windower-4-support-libraries) found [here](https://github.com/DefrostedTuna/ffxi-windower-4-support-libraries/releases).

## Installation

To install Runes, simply download the latest release from [Github](https://github.com/DefrostedTuna/ffxi-runes/releases) and place the contents into your `addons/` folder within Windower's install directory as shown below.

```
windower/
├── addons/
│   └── Runes/
│       ├── .versioninfo
│       ├── README.md
│       ├── RuneManager.lua
│       ├── Runes.lua
│       └── RuneValidator.lua
├── plugins/
├── res/
├── scripts/
├── screenshots/
├── updates/
├── videos/
├── Hook.dll
├── settings.xml
└── windower.exe
```

Once the addon has been installed it will be available within the game via `lua load runes`. Feel free to add this to your startup script as desired.

## Usage

When Runes is loaded, it will be **disabled** by default. To enable the addon, use the designated command.

```
//runes toggle on
```

Likewise, disabling the addon is just as simple.

```
//runes toggle off
```

If `on` or `off` is omitted, the addon will simply flip to the inverse of the current state. This is useful for creating a single macro to swap between states instead of relying on two explicit macros to enable or disable the addon.

**Note:** When moving between zones, the addon will revert to a **disabled** state. This is intentional so that the player may move around the world without being inadvertently interrupted every time the buffs wear upon zoning.

Applying runes is intended to blend fairly seamlessly with standard play. There are no special configuration files needed and adding a single line to a macro will be sufficient enough to get started with basic functionality.

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃<- Prev                                   Next ->┃
┃ ┏━━━━━━━━┓ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃ Ctrl 1 ┃ ┃ Ignis                            ┃ ┃
┃ ┗━━━━━━━━┛ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃ /ja "Ignis" <me>                            ┃ ┃
┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃ /console runes add ignis                    ┃ ┃ <- Blends in nicely with existing macros.
┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃                                             ┃ ┃
┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

Adding this line to a macro will forward the rune to the addon and will signify that it should be reapplied when it has dropped from the player's pool of buffs. The player's job level -- be it main job or subjob -- will automatically determine the number of runes that can be applied at any given time. It is **not** necessary to remove runes from the list before adding more if adding more will exceed the cap. If the rune cap is reached, the oldest will be removed first to make room for the new ones.

For example; if the following runes `ignis`, `sulpor`, and `gelus` were applied (in that order), applying `tenebrae` would simply remove `ignis` from the list -- leaving `sulpor`, `gelus`, and `tenebrae` to be maintained.

Saving **sets** is also available as well. This is useful for scenarios where it may be necessary to use multiple configurations based on the battle in question.

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃<- Prev                                   Next ->┃ ┃<- Prev                                   Next ->┃
┃ ┏━━━━━━━━┓ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃ ┃ ┏━━━━━━━━┓ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃ Alt F4 ┃ ┃ Glassy Thinker                   ┃ ┃ ┃ ┃ Alt F5 ┃ ┃ Seiryu                           ┃ ┃
┃ ┗━━━━━━━━┛ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃ ┃ ┗━━━━━━━━┛ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃ ┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃ /console runes set unda lux lux             ┃ ┃ ┃ ┃ /console runes set gelus tenebrae tenebrae  ┃ ┃
┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃ ┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃ ┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃                                             ┃ ┃ ┃ ┃                                             ┃ ┃
┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃ ┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃ ┃ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ┃
┃ ┃                                             ┃ ┃ ┃ ┃                                             ┃ ┃
┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃ ┃ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

The full list of commands can be found below.

### Commands

| Command                               | Valid Options                                             | Description |
|:--------------------------------------|:----------------------------------------------------------|:------------|
| `//runes toggle {?state}`             | on, off                                                   | Toggle the state of the addon. |
|                                       |                                                           | When enabled, runes will only be applied if the player is engaged, or idle. They will **not** be applied while the player is in motion (walking or running). |
|                                       |                                                           | When disabled, runes will not be automatically applied. |
|                                       |                                                           | Arguments are optional, and if not supplied, the new state will be the inverse of the current state. |
| `//runes add {rune}`                  | ignis, gelus, flabra, tellus, sulpor, unda, lux, tenebrae | Add a rune to the list of runes being maintained. |
| `//runes set {?rune} {?rune} {?rune}` | ignis, gelus, flabra, tellus, sulpor, unda, lux, tenebrae | Add a set of runes to the list of runes being maintained. |
|                                       |                                                           | Up to three runes may be added at a time (depending on level). Anything exceeding this will be ignored. If no runes are passed, the existing set of runes being maintained will be cleared. |
| `//runes clear`                       |                                                           | Clear the existing set of runes being maintained. |
| `//runes show`                        |                                                           | Print the existing set of runes being maintained to the chat log. |

---

## License

Copyright © 2022, DefrostedTuna
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Runes nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DEFROSTEDTUNA BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.