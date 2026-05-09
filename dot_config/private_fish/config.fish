#!/usr/bin/env fish

if status is-interactive
	if is_distrobox
		set dir (pwd)

		if string match -q '/run/host/*' "$dir"
			set realdir (string replace '/run/host' '' "$dir")

			if test -d "$realdir"
				cd "$realdir"
			end
		end

		echo dbox

		return
	end

	# luarocks paths
	eval (luarocks path)

	# fast node verison manager
	fnm env --use-on-cd --shell fish | source

	# has to be near the end (zellij is the only exception)
	zoxide init fish --cmd chd | source

	# custom zellij session start function
	sess_zellij
end
