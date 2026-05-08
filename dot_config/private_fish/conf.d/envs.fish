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
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx CARGO_HOME $XDG_DATA_HOME/cargo

set -gx CUDA_HOME /opt/cuda
set -gx CUDA_CACHE_PATH $XDG_CACHE_HOME/nv

set -gx GNUPGHOME $XDG_DATA_HOME/gnupg

set -gx CHROME_EXCUTABLE /var/lib/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/export/bin/io.github.ungoogled_software.ungoogled_chromium

set -gx LUAROCKS_CONFIG $HOME/.config/luarocks/config.lua

set -gx WGETRC $XDG_CONFIG_HOME/wgetrc
set -gx WGET_HSTS_FILE $XDG_DATA_HOME/wget-hsts

set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME"/npm/npmrc

#[[ path var ]]
fish_add_path /opt/cuda/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/scripts
fish_add_path $HOME/.local/share/npm/bin
fish_add_path $HOME/.local/share/nvim/mason/bin
fish_add_path $HOME/.local/luarocks/bin
