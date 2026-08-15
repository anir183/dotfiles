#!/usr/bin/env fish

source /usr/share/cachyos-fish-config/cachyos-config.fish

if status is-interactive
    # luarocks paths
    if type -q luarocks
        eval (luarocks path)
    end

    # has to be near the end (zellij is the only exception)
    zoxide init fish --cmd chd | source
end

# overwrite greeting and disable fastfetch
function fish_greeting
	# do nothing
end
