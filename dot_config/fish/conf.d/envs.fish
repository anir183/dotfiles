#!/usr/bin/env fish

set -gx fish_greeting
set -gx fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim

#[[ xdg runtime directories ]]
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

#[[ git ps1 options ]]
set -gx __fish_git_prompt_show_informative_status true
set -gx __fish_git_prompt_showdirtystate true
set -gx __fish_git_prompt_showupstream auto
set -gx __fish_git_prompt_showstashstate true
set -gx __fish_git_prompt_showcolorhints true
set -gx __fish_git_prompt_char_stateseparator ' '

#[[ environment variables for different software ]]
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"

set -gx GOPATH "$XDG_DATA_HOME/go"

set -gx CUDA_HOME /opt/cuda
set -gx CUDA_CACHE_PATH "$XDG_CACHE_HOME/nv"

set -gx DOTNET_CLI_HOME "$XDG_DATA_HOME/dotnet"
set -gx NUGET_PACKAGES "$XDG_CACHE_HOME/NuGetPackages"

set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"

set -gx CHROME_EXCUTABLE "/var/lib/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/export/bin/io.github.ungoogled_software.ungoogled_chromium"

set -gx LUAROCKS_CONFIG "$HOME/.config/luarocks/config.lua"

set -gx WGETRC "$XDG_CONFIG_HOME/wgetrc"
set -gx WGET_HSTS_FILE "$XDG_DATA_HOME/wget-hsts"

set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

#[[ path var ]]
# NOTE: fish_add_path sets another fish_user_path variables, performs some
#       checks and operations and then adds them to path
#       this causes changed ordering... use set -gx PATH if needs specific order
fish_add_path --prepend "$HOME/.local/lib/luarocks/bin"
fish_add_path --prepend "$HOME/.local/lib/dotool-1.6"
fish_add_path --prepend "$XDG_DATA_HOME/npm/bin"
fish_add_path --prepend /opt/cuda/bin

# NOTE: needs this order
set -gx PATH \
    "$HOME/.local/bin" \
    "$HOME/.local/scripts" \
    "$XDG_DATA_HOME/nvim/mason/bin" \
    "$PATH"

# # env vars
# set -gx CHROME_EXECUTABLE /run/host/var/lib/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/export/bin/io.github.ungoogled_software.ungoogled_chromium
#
# # node
# fnm env --use-on-cd --shell fish | source
#
# # java
# javm init fish | source
# set -gx _JAVA_AWT_WM_NONREPARENTING 1
#
# # zig
# fish_add_path --prepend $XDG_DATA_HOME/zvm/bin
#
# # go
# if test -s "$HOME/.g/env.fish"; and source "$HOME/.g/env.fish"
# end
#
# # flutter
# # alias flutter "fvm flutter"
# # alias dart "fvm dart"
#
# # android
# set -x ANDROID_HOME $HOME/.local/share/android-sdk
# set -x ANDROID_SDK_ROOT $ANDROID_HOME
# set -x ANDROID_AVD_HOME $XDG_CONFIG_HOME/.android/avd
#
# fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
# fish_add_path $ANDROID_HOME/platform-tools
# fish_add_path $ANDROID_HOME/emulator
#
# abbr -a emul "emulator -avd Pixel_36 -no-metrics"
