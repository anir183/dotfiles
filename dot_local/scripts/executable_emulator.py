#!/usr/bin/env python3

import os
import sys


EMULATOR = os.path.expanduser(
	"~/.local/share/android-sdk/emulator/emulator"
)

env = os.environ.copy()
env["QT_QPA_PLATFORM"] = "xcb"

os.execvpe(
	EMULATOR,
	[EMULATOR, *sys.argv[1:]],
	env,
)

# #!/usr/bin/env fish
#
# env QT_QPA_PLATFORM=xcb \
# 	$HOME/.local/share/android-sdk/emulator/emulator \
# 	$argv
