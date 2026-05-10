#!/usr/bin/env fish

function sess_zellij --description "list available sessions and attach"
	if is_distrobox
		return 1
	end

	# show help if requested
	if test (count $argv) -gt 0
		switch $argv[1]
			case "help" "h" "-h" "--help"
				echo "zellij session menu"
				echo ""
				echo "  usage:"
				echo "      just run \"sess_zellij\""
				echo ""
				echo "  behavior:"
				echo "    - if multiple active sessions exist → show fzf picker"
				echo "    - if one session exists → attach directly"
				echo "    - if none exist → create new session"
				echo ""
				echo "  fzf behavior:"
				echo "    - new-session or dont-attach → create new session or stop"
				echo "    - valid session selection → attach to that session"
				echo "    - esc or invalid query → do nothing"
				echo ""
				echo "  custom options:"
				echo "    - \"dont-attach\" → exit without attaching"
				echo "    - \"new-session\" → start new session"
				return
		end
	end

	# ensure dependencies exist
	if not command -q zellij
		echo "zellij not found"
		return 1
	end

	if not command -q fzf
		echo "fzf not found"
		return 1
	end

	# do nothing if already inside a zellij session
	if set -q ZELLIJ; and test "$ZELLIJ" = "0"
		return
	end

	# get all sessions safely
	set raw_sessions (zellij list-sessions -n 2>/dev/null)

	# extract active session names
	set active_sessions
	for s in $raw_sessions
		if test -n "$s"; and not string match -q "*EXITED*" $s
			# split only once on " ["
			set parts (string split -m1 " [" $s)
			set active_sessions $active_sessions $parts[1]
		end
	end

	set session_count (count $active_sessions)

	# multiple sessions → interactive selection
	if test $session_count -ge 2
		set options $active_sessions "new-session" "dont-attach"

		set selection (printf "%s\n" $options | fzf)

		# handle escape / fzf failure
		if test $status -ne 0
			echo "no or invalid selection"
			return
		end

		set selection (string trim $selection)

		# decision logic
		switch $selection
			case "new-session"
				zellij

			case "dont-attach"
				echo "not attaching to any session"

			case "*"
				zellij attach -c -- "$selection"
		end

		# single session → attach directly
	else if test $session_count -eq 1
		zellij attach -c

		# no sessions → create new
	else
		zellij
	end
end
