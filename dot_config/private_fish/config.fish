# commands for interactive sessions only
if status is-interactive
    # luarocks paths
    eval (luarocks path)

    # has to be near the end (zellij is the only exception)
    zoxide init fish --cmd chd | source

    # custom zellij session start function
    sess_zellij
end
