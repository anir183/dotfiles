#!/usr/bin/env fish

function update_mirrors --description "update the mirror list using reflector"
	set -l mirrorlist /etc/pacman.d/mirrorlist
	set -l backup /etc/pacman.d/mirrorlist.bak

	# Ensure reflector exists
	if not command -q reflector
		echo "[update_mirrors] reflector not found, installing..."
		sudo pacman -Sy --needed --noconfirm reflector

		if not command -q reflector
			echo "[update_mirrors] failed to install reflector"
			return 1
		end
	end

	# backup current mirrorlist
	if test -f $mirrorlist
		echo "[update_mirrors] backing up mirrorlist"
		sudo mv $mirrorlist $backup
	end

	echo "[update_mirrors] generating new mirrorlist"

	sudo reflector \
		--latest 50 \
		--country India,Singapore,Bangladesh \
		--protocol https \
		--sort rate \
		--save $mirrorlist

	if test $status -ne 0
		echo "[update_mirrors] reflector failed"

		# restore backup if generation failed
		if test -f $backup
			sudo mv $backup $mirrorlist
		end

		return 1
	end

	echo "[update_mirrors] mirrorlist updated successfully"
end
