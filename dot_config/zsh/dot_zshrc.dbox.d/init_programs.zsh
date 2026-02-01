#!/usr/bin/env zsh

# source git prompt script
. /usr/share/git/git-prompt.sh

# zoxide (has to be called at the END)
eval "$(zoxide init zsh --cmd chd)"
