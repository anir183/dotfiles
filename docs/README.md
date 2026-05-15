# dotfile

my linux dotfiles and configs for different software. managed using
[chezmoi](https://www.chezmoi.io).

### configs
* bat
* github cli
* ghostty
* git
* luarocks
* niri
* fish
* user-dirs
* wgetrc
* zellij
* opentabletdriver
* npm
* opencode

### others
* scripts

```
.
├── docs
│   └── README.md
├── dot_config
│   ├── bat
│   │   └── config
│   ├── gh
│   │   ├── private_config.yml
│   │   └── private_hosts.yml
│   ├── ghostty
│   │   ├── config
│   │   └── themes
│   │       └── dankcolors
│   ├── git
│   │   └── config
│   ├── luarocks
│   │   └── config.lua
│   ├── niri
│   │   ├── config.kdl
│   │   ├── config.kdl.bak
│   │   ├── dms
│   │   │   ├── alttab.kdl
│   │   │   ├── binds.kdl
│   │   │   ├── colors.kdl
│   │   │   ├── cursor.kdl
│   │   │   ├── layout.kdl
│   │   │   ├── outputs.kdl
│   │   │   ├── windowrules.kdl
│   │   │   └── wpblur.kdl
│   │   └── executable_float_browser_extensions.fish
│   ├── npm
│   │   └── npmrc
│   ├── opencode
│   │   └── themes
│   │       └── clear-one-dark.json
│   ├── OpenTabletDriver
│   │   ├── Plugins
│   │   ├── Presets
│   │   └── settings.json
│   ├── private_fish
│   │   ├── completions
│   │   │   ├── fnm.fish
│   │   │   ├── uv.fish
│   │   │   └── uvx.fish
│   │   ├── conf.d
│   │   │   ├── abbreviations.fish
│   │   │   ├── aliases.fish
│   │   │   ├── dbox.fish
│   │   │   ├── envs.fish
│   │   │   └── theme.fish
│   │   ├── config.fish
│   │   ├── functions
│   │   │   ├── fish_prompt.fish
│   │   │   ├── install_packages.fish
│   │   │   ├── is_distrobox.fish
│   │   │   ├── link_host_bin.fish
│   │   │   ├── sess_zellij.fish
│   │   │   └── update_mirrors.fish
│   │   └── private_fish_variables
│   ├── private_user-dirs.dirs
│   ├── wgetrc
│   └── zellij
│       ├── config.kdl
│       ├── layouts
│       │   └── 183.kdl
│       └── plugins
│           └── zjstatus.wasm
├── dot_local
│   └── scripts
│       ├── executable_emulator
│       ├── executable_obsidian-select
│       └── executable_remember
└── LICENSE
```
