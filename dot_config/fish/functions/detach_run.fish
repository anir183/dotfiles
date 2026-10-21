function detach_run --description "Launch a program independently of the current terminal"
    if test (count $argv) -eq 0
        echo "usage: detach <command> [args...]" >&2
        return 2
    end

    if command -q setsid
        command setsid --fork --wait $argv </dev/null >/dev/null 2>&1 &
    else
        command $argv </dev/null >/dev/null 2>&1 &
    end

    disown
end
