#!/usr/bin/env fish

if status is-interactive
    if is_distrobox
        return
    end

    if is_wsl
        export GALLIUM_DRIVER=d3d12
        export LIBVA_DRIVER_NAME=d3d12
        eval "$(/usr/bin/wsl2-ssh-agent)"
    end

    # luarocks paths
    if type -q luarocks
        eval (luarocks path)
    end

    # has to be near the end (zellij is the only exception)
    zoxide init fish --cmd chd | source

    if not is_wsl
        # custom zellij session start function
        sess_zellij
    end
end
