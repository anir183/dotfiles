#!/usr/bin/env python3

import os
import subprocess
import sys
from pathlib import Path


OBSIDIAN_CONFIG = (
	Path.home()
	/ ".var/app/md.obsidian.Obsidian/config/obsidian/obsidian.json"
)


def fail(message: str) -> None:
	print(f"ERROR: {message}", file=sys.stderr)
	sys.exit(1)


def main() -> None:
	try:
		config = OBSIDIAN_CONFIG.read_text()
	except OSError as exc:
		fail(f"failed to read Obsidian config: {exc}")

	# Equivalent to:
	# sed -i 's/"open":true/"open":false/g'
	updated = config.replace('"open":true', '"open":false')

	if updated != config:
		try:
			OBSIDIAN_CONFIG.write_text(updated)
		except OSError as exc:
			fail(f"failed to update Obsidian config: {exc}")

	command = [
		"flatpak",
		"run",
		"--branch=stable",
		"--arch=x86_64",
		"--command=obsidian.sh",
		"--file-forwarding",
		"md.obsidian.Obsidian",
		"@@u",
		"%U",
		"@@",
		*sys.argv[1:],
	]

	os.execvp(command[0], command)


if __name__ == "__main__":
	main()

# #!/usr/bin/env zsh
#
# sed -i 's/\"open\":true/\"open\":false/g' $HOME/.var/app/md.obsidian.Obsidian/config/obsidian/obsidian.json
# flatpak run --branch=stable --arch=x86_64 --command=obsidian.sh --file-forwarding md.obsidian.Obsidian @@u %U @@
