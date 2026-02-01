#!/usr/bin/env zsh

# source git prompt script
. /usr/share/git/git-prompt.sh

# zellij terminal multiplexer
eval "$(zellij setup --generate-auto-start zsh)"

# bat-extras
eval "$(batpipe)"

# zoxide (has to be called at the END)
eval "$(zoxide init zsh --cmd chd)"
