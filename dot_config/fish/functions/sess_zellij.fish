#!/usr/bin/env fish

function sess_zellij --description "smart zellij session manager"
    set include_all 0

    # -----------------------------
    # args
    # -----------------------------
    for arg in $argv
        switch $arg
            case -a --all
                set include_all 1

            case h help -h --help
                echo "usage: sess_zellij [--all] [--help]"
                echo ""
                echo "  default:"
                echo "    - prioritize active sessions"
                echo "    - ignore exited sessions unless needed"
                echo ""
                echo "  --all:"
                echo "    - always show picker"
                echo "    - include exited/resurrectable sessions"
                echo ""
                echo "  --help:"
                echo "    - show this dialog"
                return
        end
    end

    # -----------------------------
    # deps
    # -----------------------------
    if not command -q zellij
        echo "zellij not found"
        return 1
    end

    if not command -q fzf
        echo "fzf not found"
        return 1
    end

    # -----------------------------
    # already inside zellij
    # -----------------------------
    if set -q ZELLIJ
        return
    end

    # -----------------------------
    # collect sessions
    # -----------------------------
    set raw_sessions (zellij list-sessions -n 2>/dev/null)

    set running_sessions
    set exited_sessions

    for s in $raw_sessions
        if test -z "$s"
            continue
        end

        set parts (string split -m1 " [" $s)
        set name $parts[1]

        if string match -q "*EXITED*" -- $s
            set exited_sessions $exited_sessions $name
        else
            set running_sessions $running_sessions $name
        end
    end

    set running_count (count $running_sessions)

    # -----------------------------
    # --all override
    # -----------------------------
    if test $include_all -eq 1
        set options

        for s in $running_sessions
            set options $options $s
        end

        for s in $exited_sessions
            set options $options "[EXITED] $s"
        end

        set options $options new-session dont-attach

        set selection (
			printf "%s\n" $options |
			fzf --header="all zellij sessions"
		)

        if test $status -ne 0
            return
        end

        switch $selection
            case new-session
                zellij
                return

            case dont-attach
                return
        end

        set clean (
			string replace "[EXITED] " "" -- $selection
		)

        zellij attach -c -- "$clean"
        return
    end

    # -----------------------------
    # >1 running session
    # include exited too
    # -----------------------------
    if test $running_count -gt 1
        set options

        for s in $running_sessions
            set options $options $s
        end

        for s in $exited_sessions
            set options $options "[EXITED] $s"
        end

        set options $options new-session dont-attach

        set selection (
			printf "%s\n" $options |
			fzf --header="running sessions detected"
		)

        if test $status -ne 0
            return
        end

        switch $selection
            case new-session
                zellij
                return

            case dont-attach
                return
        end

        set clean (
			string replace "[EXITED] " "" -- $selection
		)

        zellij attach -c -- "$clean"
        return
    end

    # -----------------------------
    # exactly one running session
    # attach immediately
    # -----------------------------
    if test $running_count -eq 1
        zellij attach -c -- "$running_sessions[1]"
        return
    end

    # -----------------------------
    # no running sessions
    # create new regardless of exited
    # -----------------------------
    zellij
end
