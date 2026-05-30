#!/usr/bin/env fish

if status is-interactive
    if is_distrobox
        return
    end

    # luarocks paths
    if type -q luarocks
        eval (luarocks path)
    end

    # has to be near the end (zellij is the only exception)
    zoxide init fish --cmd chd | source

    # custom zellij session start function
    sess_zellij
end
