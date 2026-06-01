#!/usr/bin/env fish

function is_wsl --description "check if inside wsl"
    # Source - https://superuser.com/a/1828227
    # Posted by deadParrot
    # Retrieved 2026-05-31, License - CC BY-SA 4.0
    if command -q systemd-detect-virt
        test (systemd-detect-virt 2>/dev/null) = wsl
        return $status
    end

    set -q WSL_INTEROP
    and return 0

    set -q WSL_DISTRO_NAME
    and return 0

    return 1
end
