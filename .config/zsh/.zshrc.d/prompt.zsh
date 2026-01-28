#!/usr/bin/env zsh

setopt PROMPT_SUBST
autoload -U colors && colors
unset RPROMPT
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PROMPT='%F{cyan}%1~%F{reset_color} $(__git_ps1 "(%s) ")%F{reset_color}%% '
