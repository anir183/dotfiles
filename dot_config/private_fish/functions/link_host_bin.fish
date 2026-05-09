#!/usr/bin/env fish

function link_host_bin --description "Create distrobox-host-exec wrapper binaries"
	if not is_distrobox
		echo "[distrobox-host-bin] not running inside a distrobox container"
		return 1
	end

	if test (count $argv) -lt 1
		echo "usage: distrobox-host-bin <binary> [binary...]"
		return 1
	end

	set -l target_dir $HOME/.local/bin
	mkdir -p $target_dir

	for bin in $argv
		set bin (string trim -- "$bin")

		if test -z "$bin"
			continue
		end

		echo "[distrobox-host-bin] linking $bin"

		ln -sf \
			/usr/bin/distrobox-host-exec \
			$target_dir/$bin
	end
end
