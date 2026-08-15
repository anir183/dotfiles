#!/usr/bin/env fish

source /usr/share/cachyos-fish-config/cachyos-config.fish

if status is-interactive
	fish_vi_key_bindings

	# luarocks paths
	if type -q luarocks
		eval (luarocks path)
	end

	# dev tools and environment manager
	mise activate fish | source

	# has to be near the end (zellij is the only exception)
	zoxide init fish --cmd chd | source

	# start zellij session
	sess_zellij
else
	# dev tools and environment manager
	mise activate fish --shims | source
end

# overwrite greeting and disable fastfetch
function fish_greeting
	# do nothing
end
