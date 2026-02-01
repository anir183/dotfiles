#!/usr/bin/env zsh

export EDITOR=nvim

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# lines configured by zsh-newuser-install
export HISTFILE=$XDG_STATE_HOME/zsh/histfile
export HISTSIZE=1000
export SAVEHIST=2000
# end of lines configured by zsh-newuser-install

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTEAM="auto verbose name"
export GIT_PS1_SHOWCONFLICTSTATE="yes"
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_HIDE_IF_PWD_IGNORED=true

#[[ environment variables for different binaries ]]
export CUDA_HOME="/opt/cuda"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

#[[ path var ]]
PATH="/opt/cuda/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.local/scripts:$PATH"
export PATH
