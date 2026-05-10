#!/usr/bin/env fish

function is_distrobox --description "check if inside a distrobox container, optionally with a given name"
	if not test -n "$container"
		return 1
	end

	if not test -n "$CONTAINER_ID"
		return 1
	end

	if not test -n "$DISTROBOX_ENTER_PATH"
		return 1
	end

	# optionally check given name
	if test (count $argv) -ge 1
		set expected_id (string trim -- "$argv[1]")

		if test "$CONTAINER_ID" != "$expected_id"
			return 1
		end
	end

	return 0
end
